//
//  Top.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/24.
//

import Foundation
import CoreData

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

class Top: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case hotWord
        case hotWordNum
        case url
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hotWord = try container.decode(String.self, forKey: .hotWord)
        hotWordNum = try container.decode(Int64.self, forKey: .hotWordNum)
        url = try container.decode(String.self, forKey: .url)
    }
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
