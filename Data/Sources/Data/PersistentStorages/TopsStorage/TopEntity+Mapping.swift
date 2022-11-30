//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/30.
//

import Foundation
import CoreData
import Domain

extension TopEntity {
    func toDTO() -> TopDTO {
        return .init(hotWord: hotWord,
                     hotWordNum: hotWordNum,
                     url: url)
    }
}


