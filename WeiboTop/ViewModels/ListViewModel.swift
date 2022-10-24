//
//  ListViewModel.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/24.
//

import Foundation
import Alamofire

class ListViewModel: ObservableObject {
    @Published var tops = [Top]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(
            "https://v2.alapi.cn/api/new/wbtop",
            parameters: [
                "num": 10,
                "token": "LwExDtUWhF3rH5ib"
            ]
        ).responseDecodable(of: Response.self, decoder: decoder) { [weak self] response in
            switch response.result {
            case .success:
                if let data = response.value?.data {
                    self?.updateTops(data)
                }
                print("success")
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func updateTops(_ tops: [Top]) {
        self.tops = tops
    }
}
