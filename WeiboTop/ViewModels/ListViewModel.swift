//
//  ListViewModel.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/24.
//

import Foundation
import Alamofire
import CoreData

private let lastUpdatedDateKey = "lastUpdatedDate"

class ListViewModel: ObservableObject {
    @Published var tops = [Top]()
    @Published var showToast = false
    var errorMessage: String?
    let dispatchQueue = DispatchQueue(label: "org.liuduo.WeiboTop.network.response.queue")
    
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
        
        // TODO: if there are local datas, only send one request per day.
        if !hasRequestedToday() {
            loadData()
        }
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
        ).responseDecodable(of: Response.self, queue: dispatchQueue, decoder: decoder) { [weak self] response in
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
                    self.errorMessage = response.msg
                    DispatchQueue.main.async {
                        self.showToast.toggle()
                    }
                }
            case let .failure(error):
                self.errorMessage = error.localizedDescription
                DispatchQueue.main.async {
                    self.showToast.toggle()
                }
            }
        }
    }
    
    func updateTops(_ tops: [Top]) {
        // delete all datas saved before
        for top in self.tops {
            persistentContainer.viewContext.delete(top)
        }
        
        // transform dictionary to model
        DispatchQueue.main.async {
            self.tops = tops
        }
        
        // persistence
        persistentContainer.saveContext()
        
        saveUpdatedDate()
    }
    
    private func saveUpdatedDate() {
        UserDefaults.standard.set(Date.now, forKey: lastUpdatedDateKey)
        UserDefaults.standard.synchronize()
    }
    
    private func lastUpdatedDate() -> Date? {
        UserDefaults.standard.object(forKey: lastUpdatedDateKey) as? Date
    }
    
    private func hasRequestedToday() -> Bool {
        if let lastUpdatedDate = lastUpdatedDate() {
            let lastComponents = Calendar.current.dateComponents([.day], from: lastUpdatedDate)
            let nowComponents = Calendar.current.dateComponents([.day], from: .now)
            if lastComponents.day == nowComponents.day {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
