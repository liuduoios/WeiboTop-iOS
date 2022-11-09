//
//  ListViewModel.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/24.
//

import Foundation
import CoreData
import Moya
import Combine

private let lastUpdatedDateKey = "lastUpdatedDate"

@MainActor
class ListViewModel: ObservableObject {
    
    @Published var tops = [Top]()
    @Published var showToast = false
    
    var errorMessage: String?
    let dispatchQueue = DispatchQueue(label: "org.liuduo.WeiboTop.network.response.queue")
    var cancellable: AnyCancellable?
    
    let persistentContainer: PersistentContainer = {
        let container = PersistentContainer(name: "Model")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    init() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main) { notification in
                _Concurrency.Task {
                    if await !self.hasRequestedToday() {
                        do {
                            try await self.refresh()
                        } catch {
                            await self.handleError(error)
                        }
                    }
                }
            }
        
        _Concurrency.Task {
            do {
                tops = try await loadLocalData()
                if !hasRequestedToday() {
                    try await refresh()
                }
            } catch {
                handleError(error)
            }
        }
    }
    
    private func handleError(_ error: Error) {
        if let apiError = error as? APIError {
            self.errorMessage = apiError.message
            self.showToast.toggle()
        } else {
            self.errorMessage = error.localizedDescription
            self.showToast.toggle()
        }
    }
    
    private func loadLocalData() async throws -> [Top] {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let tops = try self.persistentContainer.viewContext.fetch(Top.fetchRequest()).sortAndIndexed()
                    continuation.resume(returning: tops)
                } catch {
                    print(error)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func refresh() async throws {
        self.tops = try await loadData()
    }
    
    func loadData() async throws -> [Top] {
        return try await withCheckedThrowingContinuation { continuation in
            let provider = MoyaProvider<API>()
            cancellable = provider.requestPublisher(.weiboTop(num: 20, token: "LwExDtUWhF3rH5ib"), callbackQueue: dispatchQueue)
                .sink (receiveCompletion: { completion in
                    guard case let .failure(error) = completion else {
                        return
                    }
                    continuation.resume(throwing: error)
                }, receiveValue: { response in
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let res = try decoder.decode(Response.self, from: response.data)
                        if res.code == 200 {
                            self.deleteOldTops()
                            let tops = self.topsFromDecodableTops(res.data ?? []).sortAndIndexed()
                            self.persistentContainer.saveContext()
                            self.saveUpdatedDate()
                            continuation.resume(returning: tops)
                        } else {
                            let error = APIError(code: res.code, message: res.msg)
                            continuation.resume(throwing: error)
                        }
                    } catch {
                        continuation.resume(throwing: error)
                    }
                })
        }
    }
    
    private func deleteOldTops() {
        for top in tops {
            persistentContainer.viewContext.delete(top)
        }
    }
    
    private func topsFromDecodableTops(_ decodableTops: [DecodableTop]) -> [Top] {
        var tops = [Top]()
        for decodableTop in decodableTops {
            let top = NSEntityDescription.insertNewObject(forEntityName: "Top", into: persistentContainer.viewContext) as! Top
            top.hotWord = decodableTop.hotWord
            top.hotWordNum = decodableTop.hotWordNum
            top.url = decodableTop.url
            tops.append(top)
        }
        return tops
    }
    
    private func saveUpdatedDate() {
        UserDefaults.standard.set(Date.now, forKey: lastUpdatedDateKey)
        UserDefaults.standard.synchronize()
    }
    
    private func lastUpdatedDate() -> Date? {
        UserDefaults.standard.object(forKey: lastUpdatedDateKey) as? Date
    }
    
    private func hasRequestedToday() -> Bool {
        if let lastUpdatedDate = lastUpdatedDate() {
            let lastComponents = Calendar.current.dateComponents([.hour], from: lastUpdatedDate)
            let nowComponents = Calendar.current.dateComponents([.hour], from: .now)
            if lastComponents.hour == nowComponents.hour {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
