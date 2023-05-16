//
//  HealthCard.swift
//  trees
//
//  Created by 최진용 on 2023/05/11.
//

import SwiftUI

struct HealthCard: View {
    
    @Binding var user: User?
    @Binding var healths: [Health]
    
    @EnvironmentObject var defaultMission: DefaultMission
    
    var body: some View {
        ZStack() {
            Color("backgroundColor")
                .cornerRadius(15)
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(user?.name ?? "None")
                        .foregroundColor(.white)
                        .font(.system(size: 17))
                    Spacer()
                    Text("걸음수 \(healths.first?.numberOfSteps ?? 0)/\(defaultMission.defaultWalk)")
                        .foregroundColor(Color("lightRed"))
                        .font(.system(size: 14))
                    Text("칼로리 \(healths.first?.burnedCalories ?? 0)/\(defaultMission.defaultCalories)")
                        .foregroundColor(Color("lightGreen"))
                        .font(.system(size: 14))
                    Text("운동시간 \(healths.first?.exerciseTime ?? 0)/\(defaultMission.defaultExerciseTime)")
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
