//
//  CloudKit.swift
//  trees
//
//  Created by 조기연 on 2023/05/14.
//

import Foundation
import CloudKit
import SwiftUI

class CloudKitUserInfo: ObservableObject {
    static let shared = CloudKitUserInfo()
    
    @Published var id: String = ""
    
    init() {
        fetchUserRecordId()
    }
    
    func fetchUserRecordId() {
        CKContainer.default().fetchUserRecordID() { [weak self] recordId, error in
            guard let self = self else {return}
            
            if let recordId = recordId {
                DispatchQueue.main.async {
                    self.id = recordId.recordName
                }
            }
        }
    }
}

class CloudKitNotification {
    static let shared = CloudKitNotification()
    
    private let container: CKContainer
    private let database: CKDatabase
    
    init() {
        container = CKContainer(identifier: "iCloud.it794613.trees")
        database = container.publicCloudDatabase
    }
    
    func requestNotificationPermission() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                fatalError("Failed request authorization \(error)")
            }
            
            if success {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func subcribeToNotifications(userId: String) {
        container.fetchUserRecordID { recordId, error in
            if let error = error {
                fatalError("Failed fetch user record id ::: \(error)")
            }
            
            if let recordId = recordId {
                let predicate = NSPredicate(format: "CD_relationships == %@", "invitees:invitees")
                let query = CKQuery(recordType: "CDMR", predicate: predicate)
                
                database.fetch(withQuery: query, completionHandler: <#T##(Result<(matchResults: [(CKRecord.ID, Result<CKRecord, Error>)], queryCursor: CKQueryOperation.Cursor?), Error>) -> Void#>)
            }
            
//            if let recordId = recordId {
//                let predicate = NSPredicate(format: "CD_relationships", <#T##args: CVarArg...##CVarArg#>)
//                database.fetch(withQuery: <#T##CKQuery#>) { result, error in
//
//                }
//
//
//                let subscription = CKQuerySubscription(recordType: "CD_User", predicate: predicate, subscriptionID: "invite_added_to_database", options: [.firesOnRecordUpdate])
//
//                let notification = CKSubscription.NotificationInfo()
//                notification.shouldSendContentAvailable = true
//                notification.title = "New Invite!!"
//                notification.alertBody = "Open your app"
//                notification.soundName = "default"
//
//                subscription.notificationInfo = notification
//
//                self.database.save(subscription) { _, error in
//                    if let error = error {
//                        print("Error!!!!!!!!!!")
//                        print(error.localizedDescription)
//                        return
//
//                    }
//                    print("Success Notification!!!")
//                }
//
//                self.database.fetchAllSubscriptions { subscriptions, error in
//                    print(subscriptions!.count)
//                    for subscription in subscriptions! {
//                        print(subscription.description)
//                    }
//                }
//            }
        }
    }
}
