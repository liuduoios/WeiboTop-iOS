//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/30.
//

import Foundation
import Domain
import Moya
import CombineMoya
import Combine

let apiToken = "LwExDtUWhF3rH5ib"

public final class DefaultTopsRepository {
    private let cache: TopsStorage
    private let callbackQueue = DispatchQueue(label: "org.liuduo.WeiboTop.network.response.queue")
    
    public init(cache: TopsStorage) {
        self.cache = cache
    }
}

extension DefaultTopsRepository: TopsRepositories {
    
    public func fetchTops(num: Int, completion: @escaping TopListCompletion) -> Domain.Cancellable? {
        let task = RepositoryTask()
        
        fetchFromCache(num: num) { result in
            if !self.hasRequestedCurrentHour() {
                task.cancellable = self.fetchFromNetwork(num: num, completion: completion)
            }
        }
        
        return task
    }
    
    private func fetchFromCache(num: Int, completion: @escaping TopListCompletion) {
        self.cache.getTopList(num: num) { result in
            
        }
    }
    
    private func fetchFromNetwork(num: Int, completion: @escaping TopListCompletion) -> AnyCancellable {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let provider = MoyaProvider<API>()
        return provider.requestPublisher(.weiboTop(num: num, token: apiToken), callbackQueue: callbackQueue)
            .map { response -> Data in
                response.data
            }
            .decode(type: ResponseDTO<TopDTO>.self, decoder: decoder)
            .sink(
                receiveCompletion: { comple in
                    guard case let .failure(error) = comple else {
                        return
                    }
                    completion(.failure(error))
                },
                receiveValue: { responseDTO in
                    if let error = responseDTO.error {
                        completion(.failure(error))
                    } else {
                        // Save new list
                        self.cache.save(topsResponseDTO: responseDTO)
                        
                        var topList = responseDTO.toDomain()
                        topList.sortAndIndexing()
                        completion(.success(topList))
                    }
                }
            )
    }
    
    private func hasRequestedCurrentHour() -> Bool {
        if let lastUpdatedDate = cache.lastSavedTime {
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
