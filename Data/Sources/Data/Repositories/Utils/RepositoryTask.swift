//
//  File.swift
//  
//
//  Created by liuduo on 2022/12/1.
//

import Foundation
import Domain
import Combine

class RepositoryTask: Domain.Cancellable {
    var cancellable: AnyCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        cancellable?.cancel()
        isCancelled = true
    }
}
