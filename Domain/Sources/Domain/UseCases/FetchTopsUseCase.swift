//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/29.
//

import Foundation
import Moya

public protocol FetchTopsUseCase {
    func execute(completion: @escaping (Result<TopList, Error>) -> Void) -> Cancellable?
}

public final class DefaultFetchTopsUseCase: FetchTopsUseCase {
    
    private let topsRepository: TopsRepositories
    
    public init(topsRepository: TopsRepositories) {
        self.topsRepository = topsRepository
    }
    
    public func execute(completion: @escaping (Result<TopList, Error>) -> Void) -> Cancellable? {
        return topsRepository.fetchTops(num: 20) { result in
            if case .success = result {
//                self.topsRepository.sav
            }
            
            completion(result)
        }
    }
}
