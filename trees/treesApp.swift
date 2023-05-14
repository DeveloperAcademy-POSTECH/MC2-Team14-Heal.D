//
//  treesApp.swift
//  trees
//
//  Created by 최진용 on 2023/05/08.
//

import SwiftUI

@main
struct treesApp: App {
//    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
