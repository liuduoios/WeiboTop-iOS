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
    @discardableResult
    func fetchTops(num: Int, completion: @escaping (Result<TopList, Error>) -> Void) -> Cancellable?
}
