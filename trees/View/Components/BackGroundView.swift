//
//  BackGroundView.swift
//  trees
//
//  Created by 최진용 on 2023/05/11.
//

import SwiftUI

struct BackgroundView: View {
    @Binding var isAnimation: Bool
    
    let skyGradient: [Color] = [Color("skyStart"), Color("skyMiddle"), Color("skyEnd")]
    
    var body: some View {
        GeometryReader { prx in
            let width = prx.size.width
            let height = prx.size.height
            
            VStack {
                ZStack {
                    LinearGradient(colors: skyGradient, startPoint: .top, endPoint: .bottom)
                    HStack(spacing: 0) {
                        Clouds()
                            .frame(width: 1000)
                            .offset(x: isAnimation ? -500 : 500)
                            .animation(.linear(duration: 30).repeatForever(autoreverses: false), value: isAnimation)
                        Clouds()
                            .frame(width: 1000)
                            .offset(x: isAnimation ? -500 : 500)
                            .animation(.linear(duration: 30).repeatForever(autoreverses: false), value: isAnimation)
                    }
                }.frame(width: width, height: height * 0.68)
                Image("ground").resizable().scaledToFill()
                    .offset(y: -height * 0.2)
            }
        }
        .ignoresSafeArea()
    }
}
