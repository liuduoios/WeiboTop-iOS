//
//  ListViewModel.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/24.
//

import Foundation
import CoreData
import Combine
//import CombineMoya
import UIKit
import Data
import Domain
import Infrastructure



public struct TopsListViewModelActions {
    let showTopDetail: (TopEntity) -> Void
}

public protocol TopsListViewModelInput {
    
}

public protocol TopsListViewModelOutput {
    @MainActor var tops: [Top] { get }
}

public protocol TopsListViewModel: ObservableObject, TopsListViewModelInput, TopsListViewModelOutput {}

@MainActor
public class DefaultTopsListViewModel: ObservableObject, TopsListViewModel {
    
    private let fetchTopsUseCase: FetchTopsUseCase
    
    @Published public private(set) var tops = [Top]()
    @Published public var showToast = false
    
    public private(set) var errorMessage: String?
    let dispatchQueue = DispatchQueue(label: "org.liuduo.WeiboTop.network.response.queue")
    var cancellable: AnyCancellable?
    private var topsLoadTask: Domain.Cancellable? { willSet { topsLoadTask?.cancel() } }
    
//    let persistentContainer: PersistentContainer = {
//        let bundle = Bundle(for: ListViewModel.self)
//        let businessBundleUrl = bundle.url(forResource: "Business_Business", withExtension: "bundle")!
//        let businessBundle = Bundle(url: businessBundleUrl)!
//        let modelURL = businessBundle.url(forResource: "Model", withExtension: "momd")!
//        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
//        let container = PersistentContainer(name: "Model", managedObjectModel: managedObjectModel)
//        container.loadPersistentStores { description, error in
//            if let error = error {
//                fatalError("Unable to load persistent stores: \(error)")
//            }
//        }
//        return container
//    }()
    
    public init(fetchTopsUseCase: FetchTopsUseCase,
                actions: TopsListViewModelActions? = nil) {
        self.fetchTopsUseCase = fetchTopsUseCase
//        NotificationCenter.default.addObserver(
//            forName: UIApplication.willEnterForegroundNotification,
//            object: nil,
//            queue: .main) { notification in
//                _Concurrency.Task {
//                    if await !self.hasRequestedToday() {
//                        do {
//                            try await self.refresh()
//                        } catch {
//                            await self.handleError(error)
//                        }
//                    }
//                }
//            }
//
//        _Concurrency.Task {
//            do {
//                tops = try await loadLocalData()
//                if !hasRequestedToday() {
//                    try await refresh()
//                }
//            } catch {
//                handleError(error)
//            }
//        }
        
        load(num: 20)
    }
    
    private func load(num: Int) {
        topsLoadTask = fetchTopsUseCase.execute(requestValue: .init(num: num), completion: { result in
            switch result {
            case .success(let topList):
                self.tops = topList.tops
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        })
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
    
//    private func loadLocalData() async throws -> [TopEntity] {
//        return try await withCheckedThrowingContinuation { continuation in
//            DispatchQueue.global(qos: .userInitiated).async {
//                do {
//                    let tops = try self.persistentContainer.viewContext.fetch(TopEntity.fetchRequest()).sortAndIndexed()
//                    continuation.resume(returning: tops)
//                } catch {
//                    print(error)
//                    continuation.resume(throwing: error)
//                }
//            }
//        }
//    }
}

// MARK: - Private

extension DefaultTopsListViewModel {
    
    
}
