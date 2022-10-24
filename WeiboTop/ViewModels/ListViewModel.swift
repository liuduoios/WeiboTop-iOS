//
//  ListViewModel.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/24.
//

import Foundation
import Alamofire
import CoreData

class ListViewModel: ObservableObject {
    @Published var tops = [Top]()
    
    lazy var persistentContainer: PersistentContainer = {
        let container = PersistentContainer(name: "Model")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    init() {
        // fetch a model
        let fetchRequest = NSFetchRequest<Top>(entityName: "Top")
        do {
            let tops = try persistentContainer.viewContext.fetch(fetchRequest)
            self.tops = tops
        } catch {
            print(error)
        }
        
        loadData()
    }
    
    func loadData() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.userInfo[.managedObjectContext] = persistentContainer.viewContext
        
        AF.request(
            "https://v2.alapi.cn/api/new/wbtop",
            parameters: [
                "num": 10,
                "token": "LwExDtUWhF3rH5ib"
            ]
        ).responseDecodable(of: Response.self, decoder: decoder) { [weak self] response in
            guard let `self` = self else { return }
            switch response.result {
            case .success:
                guard let response = response.value else {
                    print("the format of response is invalid")
                    return
                }
                if response.code == 0 {
                    self.updateTops(response.data ?? [])
                } else {
                    let apiError = APIError(code: response.code, msg: response.msg)
                    // TODO: give the error to UI layer
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func updateTops(_ tops: [Top]) {
        // delete all datas saved before
        for top in self.tops {
            persistentContainer.viewContext.delete(top)
        }
        
        // transform dictionary to model
        self.tops = tops
        
        // persistence
        persistentContainer.saveContext()
    }
}
