//
//  CloudKit.swift
//  trees
//
//  Created by 조기연 on 2023/05/14.
//

import Foundation
import CloudKit
import SwiftUI
import CoreData

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
                DispatchQueue.main.async(qos: .userInteractive) {
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
    
    func subcribeToNotifications() {
        container.fetchUserRecordID { recordId, error in
            if let error = error {
                fatalError("Failed fetch user record id ::: \(error)")
            }
            
            if let recordId = recordId {
                let predicate = NSPredicate(format: "CD_id == %@", recordId.recordName)
                let query = CKQuery(recordType: "CD_User", predicate: predicate)
                self.database.fetch(withQuery: query, resultsLimit: 1) { result in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    switch result {
                    case .success(let cursor):
                        if let result = cursor.matchResults.first?.0 {
                            let predicate = NSPredicate(format: "(self CONTAINS %@) AND (CD_relationships == %@)", "CD_recordNames", ":\(result.recordName)", "invitees:invitees")
                            let subscription = CKQuerySubscription(recordType: "CDMR", predicate: predicate, subscriptionID: "invite_user", options: .firesOnRecordCreation)
                            
                            let notification = CKSubscription.NotificationInfo()
                            notification.shouldSendContentAvailable = true
                            notification.title = "New Invite!!"
                            notification.alertBody = "Open your app"
                            notification.soundName = "default"
                            
                            subscription.notificationInfo = notification
                            
                            self.database.save(subscription) { _, error in
                                if let error = error {
                                    print("Error!!!!!!!!!!")
                                    print(error.localizedDescription)
                                    return
                                }
                                print("Success Notification!!!")
                            }
                        }
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
    }
}
