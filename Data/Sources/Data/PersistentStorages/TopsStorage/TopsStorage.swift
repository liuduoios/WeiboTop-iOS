//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/30.
//

import Foundation

protocol TopsStorage {
    func getTops() async throws -> Result<[TopEntity], Error>
    func save(tops: [TopEntity])
}
