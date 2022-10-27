//
//  ListViewModel.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/24.
//

import Foundation
import Alamofire
import CoreData

private let lastUpdatedDateKey = "lastUpdatedDate"

class ListViewModel: ObservableObject {
    @Published var tops = [Top]()
    @Published var showToast = false
    var errorMessage: String?
    let dispatchQueue = DispatchQueue(label: "org.liuduo.WeiboTop.network.response.queue")
    
    lazy var persistentContainer: PersistentContainer = {
        let container = PersistentContainer(name: "Model")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    init() {
        Task {
            do {
                try await loadLocalData()
                if !hasRequestedToday() {
                    loadData()
                }
            } catch {
                errorMessage = error.localizedDescription
                showToast.toggle()
            }
        }
    }
    
    func loadLocalData() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let tops = try self.persistentContainer.viewContext.fetch(Top.fetchRequest()).sortAndIndexed()
                    DispatchQueue.main.async {
                        self.tops = tops
                        continuation.resume(returning: ())
                    }
                } catch {
                    print(error)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func loadData() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(
            "https://v2.alapi.cn/api/new/wbtop",
            parameters: [
                "num": 20,
                "token": "LwExDtUWhF3rH5ib"
            ]
        ).responseDecodable(of: Response.self, queue: dispatchQueue, decoder: decoder) { [weak self] response in
            guard let `self` = self else { return }
            switch response.result {
            case .success:
                guard let response = response.value else {
                    print("the format of response is invalid")
                    return
                }
                self.handleResponse(response)
            case let .failure(error):
                self.errorMessage = error.localizedDescription
                DispatchQueue.main.async {
                    self.showToast.toggle()
                }
            }
        }
    }
    
    private func handleResponse(_ response: Response) {
        if response.code == 200 {
            if let data = response.data {
                updateTops(data)
            } else {
                updateTops([])
            }
        } else {
            errorMessage = response.msg
            DispatchQueue.main.async {
                self.showToast.toggle()
            }
        }
    }
    
    func updateTops(_ decodableTops: [DecodableTop]) {
        // delete all datas saved before
        for top in self.tops {
            persistentContainer.viewContext.delete(top)
        }
        
        // transform decodableTops to Tops
        var tops = [Top]()
        for decodableTop in decodableTops {
            let top = NSEntityDescription.insertNewObject(forEntityName: "Top", into: persistentContainer.viewContext) as! Top
            top.hotWord = decodableTop.hotWord
            top.hotWordNum = decodableTop.hotWordNum
            top.url = decodableTop.url
            tops.append(top)
        }
        tops = tops.sortAndIndexed()
        DispatchQueue.main.async {
            self.tops = tops
        }
        
        // persistence
        persistentContainer.saveContext()
        
        saveUpdatedDate()
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
