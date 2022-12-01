//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/30.
//

import Foundation

public struct TopList: Equatable {
    public var tops: [Top]
    
    /// Sort by hotWordNum and set index for per item
    public mutating func sortAndIndexing() {
        var tops = tops.sorted {
            $0.hotWordNum ?? 0 > $1.hotWordNum ?? 0
        }
        for index in 0..<tops.count {
            tops[index].index = index
        }
        self.tops = tops
    }
    
    public init(tops: [Top]) {
        self.tops = tops
    }
}
