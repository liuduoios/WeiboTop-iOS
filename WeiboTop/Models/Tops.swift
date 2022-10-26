//
//  Tops.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/26.
//

import Foundation

extension Array where Element == Top {
    func sortAndIndexed() -> [Top] {
        let tops = sorted {
            $0.hotWordNum > $1.hotWordNum
        }
        for (index, top) in tops.enumerated() {
            top.index = Int16(index)
        }
        return tops
    }
}
