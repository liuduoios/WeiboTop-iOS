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
    
    func toDomain() -> Top {
        return .init(hotWord: hotWord,
                     hotWordNum: hotWordNum,
                     url: url)
    }
}

extension Array where Element == TopEntity {
    func toDomain() -> TopList {
        var tops = [Top]()
        for entity in self {
            tops.append(entity.toDomain())
        }
        return TopList(tops: tops)
    }
}

extension TopDTO {
    func toEntity(in context: NSManagedObjectContext) -> TopEntity {
        let entity = TopEntity(context: context)
        entity.hotWord = hotWord ?? ""
        entity.hotWordNum = hotWordNum ?? 0
        entity.url = url ?? ""
        return entity
    }
}


