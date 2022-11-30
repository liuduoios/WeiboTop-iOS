//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/30.
//

import Foundation
import CoreData

final class CoreDataTopsStorage {
    
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
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
    func getTops() async throws -> Result<[TopEntity], Error> {
        return try await withCheckedThrowingContinuation { continuation in
            coreDataStorage.performBackgroundTask { context in
                do {
                    let fetchRequest = self.fetchRequest()
                    let results = try context.fetch(fetchRequest)
                    continuation.resume(returning: Result.success(results))
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func save(tops: [TopEntity]) {
        
    }
}
