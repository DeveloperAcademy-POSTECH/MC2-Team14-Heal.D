//
//  OnBoardingTest.swift
//  trees
//
//  Created by 최진용 on 2023/05/15.
//

import SwiftUI

struct OnBoardingTest: View {
//    @Environment(\.managedObjectContext) private var viewContext
    @State private var text: String = ""
//    @FetchRequest
//    var users: FetchedResults<User>
    
    var body: some View {
        VStack {
            Text("이름을 입력하세요")
            TextField("enter your name",text: $text).padding()
            Button {
//                initialize(name: text)
                print("text")
            } label: {
                Text("Start!")
            }
        }
    }
//
//    init() {
//        _users = FetchRequest<User>(
//            entity: User.entity(),
//            sortDescriptors: []
//            //            predicate: NSPredicate(format: "code == %@", "9B1B6E")
//        )
//    }
//
//    private func initialize(name: String) {
//        let user = User(context: viewContext)
//        user.id = CloudKitUserInfo.shared.id
//        user.name = name
//        user.code = String(UUID().uuidString.prefix(6))
//
//        let grow = Grow(context: viewContext)
//        grow.id = UUID()
//        grow.day = 1
//        grow.level = 1
//
//        let badge = Badge(context: viewContext)
//        badge.id = UUID()
//        badge.badges = []
//        for name in BadgeModel.names {
//            badge.badges!.append(BadgeModel(name: name))
//        }
//
//        user.badge = badge
//        user.grow = grow
//        user.familys = [user]
//
//        grow.user = user
//
//        badge.user = user
//
//        try? viewContext.save()
//    }
}

struct OnBoardingView_Preview: PreviewProvider {
    static var previews: some View {
        OnBoardingTest()
    }
}
