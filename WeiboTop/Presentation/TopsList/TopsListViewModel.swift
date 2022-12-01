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
    var tops: [TopEntity] { get }
}

public protocol TopsListViewModel: TopsListViewModelInput, TopsListViewModelOutput {}

@MainActor
public class DefaultTopsListViewModel: ObservableObject, TopsListViewModel {
    
    private let fetchTopsUseCase: FetchTopsUseCase
    private let actions: TopsListViewModelActions?
    
    @Published public private(set) var tops = [TopEntity]()
    @Published public var showToast = false
    
    public private(set) var errorMessage: String?
    let dispatchQueue = DispatchQueue(label: "org.liuduo.WeiboTop.network.response.queue")
    var cancellable: AnyCancellable?
    private var topsLoadTask: Cancellable? { willSet { topsLoadTask?.cancel() } }
    
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
        self.actions = actions
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
    }
    
    private func load() {
//        Task {
//            topsLoadTask = await fetchTopsUseCase.execute()
//        }
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
