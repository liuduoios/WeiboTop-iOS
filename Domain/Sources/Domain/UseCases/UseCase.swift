//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/29.
//

import Foundation
import Infrastructure

public protocol UseCase {
    @discardableResult
    func start() -> Cancellable?
}
