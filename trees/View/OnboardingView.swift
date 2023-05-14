//
//  OnboardingView.swift
//  trees
//
//  Created by 조기연 on 2023/05/14.
//

import SwiftUI
import CloudKit

struct OnboardingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    private let userInfo: CloudKitUserInfo = CloudKitUserInfo.shared
    
    @State private var destination: String? = nil
    
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: []
    )
    var users: FetchedResults<User>
    
    var body: some View {
        VStack(spacing: 30) {
            List {
                ForEach(self.users, id: \.self) { user in
                    Text(user.code! + " " + user.id!)
                }
            }
            
            Button {
                initialize(name: "Test!")
            } label: {
                Text("Start!")
            }
        }
        .font(.title3)
        .fontWeight(.semibold)
    }
    
    private func initialize(name: String) {
        let user = User(context: viewContext)
        user.id = userInfo.id
        user.name = name
        user.code = String(UUID().uuidString.prefix(6))
        
        let grow = Grow(context: viewContext)
        grow.id = UUID()
        grow.day = 0
        grow.level = 0

        
        let badge = Badge(context: viewContext)
        badge.id = UUID()
        badge.badge1 = BadgeModel()
        
        user.familys = NSSet(object: user)
        user.grow = grow
        user.badge = badge
        
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
