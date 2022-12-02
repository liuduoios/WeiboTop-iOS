//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/30.
//

import Foundation
import CoreData
import Domain

private let lastUpdatedDateKey = "lastUpdatedDate"

public final class CoreDataTopsStorage {
    
    private let coreDataStorage: CoreDataStorage
    
    public convenience init() {
        self.init(coreDataStorage: CoreDataStorage.shared)
    }
    
    init(coreDataStorage: CoreDataStorage) {
        self.coreDataStorage = coreDataStorage
    }
    
    private func fetchRequest() -> NSFetchRequest<TopEntity> {
        let request = TopEntity.fetchRequest()
        return request
    }
    
    private func deleteAllTops(in context: NSManagedObjectContext) {
        let request = fetchRequest()
        do {
            for topEntity in try context.fetch(request) {
                context.delete(topEntity)
            }
        } catch {
            print(error)
        }
    }
}

extension CoreDataTopsStorage: TopsStorage {
    public func getTopList(num: Int, completion: @escaping (Result<TopList, Error>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest()
                let results = try context.fetch(fetchRequest)
                completion(.success(results.toDomain()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func save(topsResponseDTO: TopsResponseDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteAllTops(in: context)
                
                if let topDTOs = topsResponseDTO.data {
                    for topDTO in topDTOs {
                        _ = topDTO.toEntity(in: context)
                    }
                }
                
                try context.save()
            } catch {
                print("CoreDataTopsStorage save error: \(error)")
            }
        }
    }
    
    public var lastSavedTime: Date? {
        get {
            return UserDefaults.standard.object(forKey: lastUpdatedDateKey) as? Date
        }
        set {
            UserDefaults.standard.set(Date.now, forKey: lastUpdatedDateKey)
            UserDefaults.standard.synchronize()
        }
    }
}
