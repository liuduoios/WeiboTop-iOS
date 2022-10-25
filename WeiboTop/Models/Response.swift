//
//  Response.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/24.
//

import Foundation
import CoreData

struct Response: Decodable {
    let code: Int
    let msg: String
    let data: [DecodableTop]?
    let time: TimeInterval
    let logId: Int64
}
