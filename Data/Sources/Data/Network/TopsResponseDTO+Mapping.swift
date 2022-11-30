//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/30.
//

import Foundation
import Domain

public extension TopsResponseDTO {
    func toDomain() -> TopList {
        if let datas = data {
            let tops = datas.map { $0.toDomain() }
            return .init(tops: tops)
        } else {
            return .init(tops: [])
        }
    }
}

public extension TopDTO {
    func toDomain() -> Top {
        return .init(hotWord: hotWord,
                     hotWordNum: hotWordNum,
                     url: url)
    }
}
