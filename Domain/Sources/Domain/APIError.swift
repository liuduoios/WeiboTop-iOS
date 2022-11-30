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
    
    public func localizedDescription() -> String {
        return message
    }
}
