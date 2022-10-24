//
//  Top+Extensions.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/24.
//

import Foundation

extension Top {
    func updateWithDictionary(_ dictionary: [String: Any]) {
        hotWord = (dictionary["hotWord"] as? String) ?? ""
        hotWordNum = (dictionary["hotWordNum"] as? Int64) ?? 0
        url = (dictionary["url"] as? String) ?? ""
    }
}
