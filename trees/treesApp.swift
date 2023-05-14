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
    let userInfo = CloudKitUserInfo.shared

    // cloudKit userid를 구한 뒤 userId를 넘겨주고 user를 찾을 수 있도록 한뒤
    // 있으면 MainView()
    // 없으면 OnboardingView()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
