//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/29.
//

import Foundation
import Infrastructure

public protocol FetchTopsUseCase {
    func execute() -> Cancellable?
}

final class DefaultFetchTopsUseCase {
    
}
