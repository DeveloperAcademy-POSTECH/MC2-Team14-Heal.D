//
//  CloudView.swift
//  MC2
//
//  Created by 송재훈 on 2023/05/10.
//

import SwiftUI

struct CloudView: View {
    @State var button = false
    @State var isAnimation = false
    var body: some View {
        VStack() {
            Button(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/) {
                    isAnimation.toggle()
            }
            
            HStack(){
                Image("Cloud")
                    .resizable()
                    .frame(width: 400, height: UIScreen.main.bounds.height * 0.5)
                    .offset(x: isAnimation ? -200 : 200)
                    .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: isAnimation)

                Image("Cloud")
                    .resizable()
                    .frame(width: 400, height: UIScreen.main.bounds.height * 0.5)
                    .offset(x: isAnimation ? -200 : 200)
                    .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: isAnimation)
            }
        }
    }
}

struct CloudView_Previews: PreviewProvider {
    static var previews: some View {
        CloudView()
    }
}
