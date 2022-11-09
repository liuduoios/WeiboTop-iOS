//
//  API.swift
//  WeiboTop
//
//  Created by liuduo on 2022/11/9.
//

import Foundation
import Moya

enum API {
    case weiboTop(num: Int, token: String)
}

extension API: TargetType {
    var baseURL: URL {
        return URL(string: "https://v2.alapi.cn/api")!
    }
    
    var path: String {
        switch self {
        case .weiboTop:
            return "/new/wbtop"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .weiboTop:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .weiboTop(num, token):
            return .requestParameters(parameters: ["num": num, "token": token],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
