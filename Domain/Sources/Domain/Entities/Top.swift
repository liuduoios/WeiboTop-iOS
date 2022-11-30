//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/30.
//

import Foundation

public struct Top: Equatable, Identifiable {
    public var id: Int { return index }
    var index: Int
    
    public let hotWord: String?
    public let hotWordNum: Int64?
    public let url: String?
    
    public init(index: Int = 0, hotWord: String?, hotWordNum: Int64?, url: String?) {
        self.index = index
        self.hotWord = hotWord
        self.hotWordNum = hotWordNum
        self.url = url
    }
}
