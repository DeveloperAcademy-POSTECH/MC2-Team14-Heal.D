//
//  Persistence.swift
//  trees
//
//  Created by 최진용 on 2023/05/08.
//

import CoreData
import Foundation
import CloudKit
import SwiftUI

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "trees")
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve ta persistent store description.")
        }
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        let options = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.it794613.trees")
        options.databaseScope = .public
        
        description.cloudKitContainerOptions = options
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        #if DEBUG
        do {
            try container.initializeCloudKitSchema()
        } catch {
            print("=======================================")
            print("\(#function): initializeCloudKitSchema: \(error)")
            print("=======================================")
        }
        #endif
        
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("#\(#function): Failed to pin viewContext to the current generation:\(error)")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
