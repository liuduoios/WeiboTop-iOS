//
//  APIError.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/24.
//

import Foundation

struct APIError: Error {
    let code: Int
    let msg: String
}
