//
//  AlartListCell.swift
//  trees
//
//  Created by 최진용 on 2023/05/11.
//

import SwiftUI

struct AlarmListCell: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @Binding var reload: Bool
    
    var text: String
    
    let inviter: User
    let user: User
    
    var body: some View {
        HStack {
            Text("\(text)")
            Spacer()
            Button {
                user.addToFamilys(inviter)
                user.removeFromInvitees(inviter)
                
                inviter.addToFamilys(user)
                inviter.removeFromInvitees(user)
                
                try? viewContext.save()
                
                viewContext.refresh(user, mergeChanges: false)
                viewContext.refresh(inviter, mergeChanges: false)
                
                reload.toggle()
            } label: {
                Text("수락")
                    .foregroundColor(.white)
            }.frame(width: 60, height: 30)
                .background(Color.accentColor)
                .cornerRadius(8)
            
            Button {
                user.removeFromInvitees(inviter)
                inviter.removeFromInvitees(user)
                
                try? viewContext.save()
                
                viewContext.refresh(user, mergeChanges: false)
                viewContext.refresh(inviter, mergeChanges: false)
                
                reload.toggle()
            } label: {
                Text("거절")
                    .foregroundColor(.white)
                    .background(Color.gray)
            }.frame(width: 60, height: 30)
                .background(Color.gray)
                .cornerRadius(8)
        }
    }
}
