//
//  FamilyCard.swift
//  trees
//
//  Created by 최진용 on 2023/05/16.
//

import SwiftUI

struct FamilyCard: View {
    @EnvironmentObject var defaults: DefaultMission
    
    var body: some View {
        ZStack() {
            Color("backgroundColor")
                .cornerRadius(15)
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("가족")
                        .foregroundColor(.white)
                        .font(.system(size: 17))
                    Spacer()
                    Text("걸음수 \(defaults.defaultWalk)/20000")
                        .foregroundColor(Color("lightRed"))
                        .font(.system(size: 14))
                    Text("칼로리 \(defaults.defaultCalories)/3000")
                        .foregroundColor(Color("lightGreen"))
                        .font(.system(size: 14))
                    Text("운동시간 \(defaults.defaultExerciseTime)/30")
                        .foregroundColor(Color("lightBlue"))
                        .font(.system(size: 14))
                    Spacer()
                }
                Spacer()
                HealthRing(big: .constant(0.1), medium: .constant(0.5), small: .constant(0.5))
                    .frame(width: 40, height: 40)
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

