//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/29.
//

import Foundation

public protocol FetchTopsUseCase {
    func execute(requestValue: FetchTopsUseCaseRequestValue,
                 completion: @escaping (Result<TopList, Error>) -> Void) -> Cancellable?
}

public final class DefaultFetchTopsUseCase: FetchTopsUseCase {
    
    private let topsRepository: TopsRepositories
    
    public init(topsRepository: TopsRepositories) {
        self.topsRepository = topsRepository
    }
    
    public func execute(requestValue: FetchTopsUseCaseRequestValue,
                        completion: @escaping (Result<TopList, Error>) -> Void) -> Cancellable? {
        return topsRepository.fetchTops(num: requestValue.num) { result in
            completion(result)
        }
    }
}

public struct FetchTopsUseCaseRequestValue {
    // Number of Tops
    let num: Int
    
    public init(num: Int) {
        self.num = num
    }
}
