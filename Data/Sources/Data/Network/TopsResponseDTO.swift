//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/30.
//

import Foundation

public typealias TopsResponseDTO = ResponseDTO<TopDTO>

public struct TopDTO: Decodable {
    public let hotWord: String?
    public let hotWordNum: Int64?
    public let url: String?
}
