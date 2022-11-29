//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/29.
//

import Foundation
import Infrastructure

protocol TopsRepositories {
    @discardableResult
    func fetchTops() -> Cancellable?
}
