//
//  Top.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/25.
//

import Foundation

struct DecodableTop: Decodable {
    let hotWord: String
    let hotWordNum: Int64
    let url: String
}
