//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/29.
//

import Foundation
import Infrastructure
import Moya

public protocol TopsRepositories {
    typealias TopListCompletion = (Result<TopList, Error>) -> Void
    
    @discardableResult
    func fetchTops(num: Int, completion: @escaping TopListCompletion) -> Cancellable?
}
