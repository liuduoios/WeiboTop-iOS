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

let apiToken = "LwExDtUWhF3rH5ib"

public final class DefaultTopsRepository {
    private let cache: TopsStorage
    private let callbackQueue = DispatchQueue(label: "org.liuduo.WeiboTop.network.response.queue")
    
    public init(cache: TopsStorage) {
        self.cache = cache
    }
}

extension DefaultTopsRepository: TopsRepositories {
    public func fetchTops(num: Int, completion: @escaping (Result<TopList, Error>) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        
        let provider = MoyaProvider<API>()
        _ = provider.requestPublisher(.weiboTop(num: num, token: apiToken), callbackQueue: callbackQueue)
            .sink { comple in
                guard case let .failure(error) = comple else {
                    return
                }
                completion(.failure(error))
            } receiveValue: { response in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let res = try decoder.decode(ResponseDTO<TopDTO>.self, from: response.data)
                    if res.code == 200 {
                        // TODO: delete all
                        
                        // Save new list
                        var topList = res.toDomain()
                        topList.sortAndIndexing()
                        self.cache.save(topList: topList)
                        
                        completion(.success(topList))
                    } else {
                        let error = APIError(code: res.code, message: res.msg)
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        
        return task
    }
    
    private func hasRequestedToday() -> Bool {
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
