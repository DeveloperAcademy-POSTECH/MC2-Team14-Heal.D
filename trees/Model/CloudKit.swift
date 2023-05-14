//
//  CloudKit.swift
//  trees
//
//  Created by 조기연 on 2023/05/14.
//

import Foundation
import CloudKit

class CloudKitUserInfo {
    static let shared = CloudKitUserInfo()
    
    var id: String = ""
    
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
