//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/17.
//

import Foundation

public extension String {
    
    func encodeQuery() -> String {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
}
