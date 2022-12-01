//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/30.
//

import Foundation
import Domain

public protocol TopsStorage {
    
    /// 获取热搜列表
    func getTopList() async throws -> Result<TopList, Error>
    
    /// 保存热搜列表
    func save(topList: TopList)
    
    /// 上次保存时间
    var lastSavedTime: Date? { get set }
}
