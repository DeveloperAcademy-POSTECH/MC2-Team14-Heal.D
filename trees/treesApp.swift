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
    @State private var userId: String = ""
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView() {
                    MainView(userId: $userId)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            }.onAppear {
                userId = userInfo.id
            }.onChange(of: userInfo.id) { newValue in
                userId = newValue
            }
        }
    }
}
