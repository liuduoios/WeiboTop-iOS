//
//  Top.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/25.
//

import Foundation

struct DecodableTop: Decodable, Hashable, Sendable {
    let hotWord: String
    let hotWordNum: Int64
    let url: String
}
