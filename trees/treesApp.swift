//
//  treesApp.swift
//  trees
//
//  Created by 최진용 on 2023/05/08.
//

import SwiftUI

@main
struct treesApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var userInfo = CloudKitUserInfo.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView() {
                    MainView(userId: userInfo.id)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            }
        }
    }
}
