//
//  APIError.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/27.
//

import Foundation

struct APIError: Error {
    let code: Int
    let message: String
    
    func localizedDescription() -> String {
        return message
    }
}
