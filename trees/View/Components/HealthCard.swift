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
                    Text("걸음수")
                        .foregroundColor(Color("lightRed"))
                    Text("활동칼로리")
                        .foregroundColor(Color("lightGreen"))
                    Text("운동시간")
                        .foregroundColor(Color("lightBlue"))
                }
                Spacer()
                HealthRing(big: .constant(1.0), medium: .constant(1.0), small: .constant(1.0))
                    .frame(width: 80, height: 80)
                    .padding(.trailing, 30)
                
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
