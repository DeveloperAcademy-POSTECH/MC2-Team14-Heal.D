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
    
    @FetchRequest
    var users: FetchedResults<User>
    
    var body: some View {
        VStack(spacing: 30) {
            TextEditor(text: $text)
                .background(.yellow)
            
            List {
                ForEach(users, id: \.self) { user in
                    Text(user.name!)
                }
            }
            
            Button {
                initialize(name: text)
            } label: {
                Text("Start!")
            }
        }
        .font(.title3)
        .fontWeight(.semibold)
    }
    
    init() {
        _users = FetchRequest<User>(
            entity: User.entity(),
            sortDescriptors: []
//            predicate: NSPredicate(format: "code == %@", "9B1B6E")
        )
    }
    
    private func initialize(name: String) {
        let user = User(context: viewContext)
        user.id = CloudKitUserInfo.shared.id
        user.name = name
        user.code = String(UUID().uuidString.prefix(6))
        
        let grow = Grow(context: viewContext)
        grow.id = UUID()
        grow.day = 1
        grow.level = 1
        
        let badge = Badge(context: viewContext)
        badge.id = UUID()
        badge.badges = []
        for name in BadgeModel.names {
            badge.badges!.append(BadgeModel(name: name))
        }
        
        user.badge = badge
        user.grow = grow
        user.familys = [user]
        
        grow.user = user
        
        badge.user = user
        
        try? viewContext.save()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
