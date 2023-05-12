//
//  ButtonView.swift
//  MC2
//
//  Created by 송재훈 on 2023/05/12.
//

import SwiftUI

struct ButtonView: View {
    @State var showSheet: Bool = false
    
    var body: some View {
        HStack() {
            Button {
                showSheet.toggle()
            } label: {
                Image("reward")
            }
            .padding(.leading, 30)
            .frame(maxWidth: .infinity, alignment: .leading)
            .sheet(isPresented: $showSheet) {
                BadgeView()
                    .presentationDetents([.fraction(0.4)])
                    .presentationDragIndicator(.visible)
            }
            
            NavigationLink {
                AlartListView()
            } label: {
                Image("alarm")
            }
            .padding(.trailing, 30)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView()
    }
}
