//
//  Response.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/24.
//

import Foundation

struct Response: Decodable {
    let code: Int
    let msg: String
    let data: [Top]
}
