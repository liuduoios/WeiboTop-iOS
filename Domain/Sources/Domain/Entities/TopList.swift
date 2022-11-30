//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/30.
//

import Foundation

public struct TopList: Equatable {
    public let tops: [Top]
    
    public func sortAndIndexed() -> [Top] {
        var tops = tops.sorted {
            $0.hotWordNum > $1.hotWordNum
        }
        for index in 0..<tops.count {
            tops[index].index = index
        }
        return tops
    }
    
    public init(tops: [Top]) {
        self.tops = tops
    }
}
