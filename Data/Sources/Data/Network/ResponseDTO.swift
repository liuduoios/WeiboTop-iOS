//
//  Response.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/24.
//

import Foundation
import CoreData

public struct ResponseDTO<DataType: Decodable>: Decodable {
    public let code: Int
    public let msg: String
    public let data: [DataType]?
    public let time: TimeInterval
    public let logId: Int64
}
