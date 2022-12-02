//
//  APIError.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/27.
//

import Foundation

public struct APIError: Error {
    public let code: Int
    public let message: String
    
    public var localizedDescription: String {
        return message
    }
    
    public init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
}
