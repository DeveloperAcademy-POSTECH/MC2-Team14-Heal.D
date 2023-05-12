//
//  BackgroundView.swift
//  MC2
//
//  Created by 송재훈 on 2023/05/12.
//

import SwiftUI

struct BackgroundView: View {
    @State var isAnimation = false
    
    var body: some View {
        GeometryReader { geo in
            let geoWidth = geo.size.width
            let geoHeight = geo.size.height
            
            Image("Sky")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            HStack(spacing: 0){
                Group {
                    Image("Cloud")
                        .resizable()
                    Image("Cloud")
                        .resizable()
                }
                .frame(width: geoWidth * 1.2, height: geoHeight * 0.8)
                .offset(x: isAnimation ? -geoWidth * 1.2 : geoWidth * 0, y: 0)
                .onAppear {
                    DispatchQueue.main.async {
                        withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                            isAnimation = true
                        }
                    }
                }
                
               
            }
            
            Image("Land")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea()
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
