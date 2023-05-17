//
//  AlartListView.swift
//  trees
//
//  Created by 최진용 on 2023/05/11.
//

import SwiftUI

struct AlarmListView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var reload = false
    
    var datas: [String] = []
    
    let user: User?
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            
            ScrollView {
                VStack {
                    Text(reload.description).opacity(0.0)
                    if user?.invitees?.count == 0 {
                        Text("초대 리스트가 없습니다.").frame(width: width, height: height)
                    } else {
                        ForEach(user?.invitees?.allObjects as! [User], id: \.self) { inviter in
                            AlarmListCell(reload: $reload, text: "\(inviter.name!)에게 초대가 도착했습니다.", inviter: inviter, user: user!)
                                .environment(\.managedObjectContext, viewContext)
                            Divider()
                        }
                    }
                }
            }
        }.padding()
    }
}
