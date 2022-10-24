//
//  Top.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/24.
//

import Foundation

struct Top: Identifiable, Decodable {
    var id: String {
        return url
    }
    
    let hotWord: String
    let hotWordNum: UInt
    let url: String
}
