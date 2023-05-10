//
//  HealthApp.swift
//  Health
//
//  Created by 조기연 on 2023/05/10.
//

import SwiftUI

@main
struct HealthApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
