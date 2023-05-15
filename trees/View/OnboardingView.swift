//
//  OnboardingView.swift
//  trees
//
//  Created by 조기연 on 2023/05/14.
//

import SwiftUI
import CloudKit
import CoreData

struct OnboardingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var text: String = ""
    @Binding var isFirst: Bool
    
    let userId: String
    
    var body: some View {
        VStack(spacing: 30) {
            TextEditor(text: $text)
                .background(.yellow)
            Button {
                initialize(name: text)
                isFirst.toggle()
            } label: {
                Text("Start!")
            }
            
            Button {
                CloudKitNotification.shared.requestNotificationPermission()
                CloudKitNotification.shared.subcribeToNotifications(userId: userId)
            } label: {
                Text("subscriptions")
            }
        }
        .font(.title3)
        .fontWeight(.semibold)
    }
    
    private func initialize(name: String) {
        let user = User(context: viewContext)
        user.id = userId
        user.name = name
        user.code = String(UUID().uuidString.prefix(6))
        user.badges = []
        for name in BadgeModel.names {
            user.badges!.append(BadgeModel(name: name, isOn: false, isLock: false))
        }
        
        let grow = Grow(context: viewContext)
        grow.id = UUID()
        grow.day = 1
        grow.level = 1
        
        user.grow = grow
        user.familys = [user]
        
        grow.user = user
        
        try? viewContext.save()
    }
}
