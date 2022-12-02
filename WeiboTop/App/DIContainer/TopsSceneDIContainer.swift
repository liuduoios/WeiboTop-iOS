//
//  TopListSceneDIContainer.swift
//  WeiboTop
//
//  Created by liuduo on 2022/12/1.
//

import Foundation
import Domain
import Data

final class TopsSceneDIContainer {
    
    lazy var topsStorage: TopsStorage = CoreDataTopsStorage()
    
    // MARK: - Use Cases
    
    func makeFetchTopsUseCase() -> FetchTopsUseCase {
        return DefaultFetchTopsUseCase(topsRepository: makeTopsRepository())
    }
    
    // MARK: - Repositories
    
    func makeTopsRepository() -> TopsRepositories {
        return DefaultTopsRepository(cache: topsStorage)
    }
    
    // MARK: - Tops List
    
    @MainActor func makeTopsListViewModel() -> any TopsListViewModel {
        return DefaultTopsListViewModel(fetchTopsUseCase: makeFetchTopsUseCase())
    }
}
