//
//  File.swift
//  
//
//  Created by liuduo on 2022/12/1.
//

import Foundation
import Moya

class RepositoryTask: Cancellable {
//    var networkTask: NetworkCan
    var isCancelled: Bool = false
    
    func cancel() {
        isCancelled = true
    }
}
