//
//  HealthCard.swift
//  trees
//
//  Created by 최진용 on 2023/05/11.
//

import SwiftUI

struct HealthCard: View {
    var body: some View {
        ZStack() {
            Color("backgroundColor")
                .cornerRadius(15)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("이름")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                    Spacer()
                    Text("걸음수 1000/1000")
                        .foregroundColor(Color("lightRed"))
                        .font(.system(size: 15))
                    Text("칼로리 1200/1200")
                        .foregroundColor(Color("lightGreen"))
                        .font(.system(size: 15))
                    Text("운동시간 10/10")
                        .foregroundColor(Color("lightBlue"))
                        .font(.system(size: 15))
                    Spacer()
                }
                Spacer()
                HealthRing(big: .constant(0.1), medium: .constant(0.5), small: .constant(0.5))
                    .frame(width: 70, height: 70)
                    .padding(.trailing, 20)
                
            }
            .padding()
        }
    }
}

struct CardView_Preview: PreviewProvider {
    static var previews: some View {
        HealthCard()
    }
}
