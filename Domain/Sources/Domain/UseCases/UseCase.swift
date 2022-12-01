//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/29.
//

import Foundation
import Moya

public protocol UseCase {
    @discardableResult
    func start() -> Cancellable?
}
