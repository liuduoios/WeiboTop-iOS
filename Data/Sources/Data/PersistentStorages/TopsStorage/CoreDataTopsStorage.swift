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
    
    private func deleteTops(in context: NSManagedObjectContext) {
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
    public func getTopList() async throws -> Result<TopList, Error> {
        return try await withCheckedThrowingContinuation { continuation in
            coreDataStorage.performBackgroundTask { context in
                do {
                    let fetchRequest = self.fetchRequest()
                    let results = try context.fetch(fetchRequest)
                    continuation.resume(returning: Result.success(results.toDomain()))
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func deleteAll() {
        
    }
    
    public func save(topList: TopList) {
        coreDataStorage.saveContext()
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
