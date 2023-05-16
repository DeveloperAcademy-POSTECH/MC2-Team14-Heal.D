//
//  HealthCard.swift
//  trees
//
//  Created by 최진용 on 2023/05/11.
//

import SwiftUI

struct HealthCard: View {
    @Binding var user: User?
    @ObservedObject var healthData: HealthData
    @EnvironmentObject var defaultMission: DefaultMission
    
    @State var bigProgress: CGFloat = 0.0
    @State var mediumProgress: CGFloat = 0.0
    @State var smallProgress: CGFloat = 0.0
    
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
                    Text("걸음수 \(healthData.numberOfSteps > defaultMission.defaultWalk ? defaultMission.defaultWalk : healthData.numberOfSteps)/\(defaultMission.defaultWalk)")
                        .foregroundColor(Color("lightRed"))
                        .font(.system(size: 14))
                    Text("칼로리 \(healthData.burnedCalories > defaultMission.defaultCalories ? defaultMission.defaultCalories : healthData.burnedCalories)/\(defaultMission.defaultCalories)")
                        .foregroundColor(Color("lightGreen"))
                        .font(.system(size: 14))
                    Text("운동시간 \(healthData.exerciseTime > defaultMission.defaultExerciseTime ? defaultMission.defaultExerciseTime : healthData.exerciseTime)/\(defaultMission.defaultExerciseTime)")
                        .foregroundColor(Color("lightBlue"))
                        .font(.system(size: 14))
                    Spacer()
                }
                Spacer()
                HealthRing(big: $bigProgress, medium: $mediumProgress, small: $smallProgress)
                    .frame(width: 40, height: 40)
                    .padding(.trailing, 30)
                    .onAppear {
                        bigProgress = CGFloat(healthData.numberOfSteps) / CGFloat(defaultMission.defaultWalk)
                        mediumProgress = CGFloat(healthData.burnedCalories) / CGFloat(defaultMission.defaultCalories)
                        smallProgress = CGFloat(healthData.exerciseTime) / CGFloat(defaultMission.defaultExerciseTime)
                    }
            }
            .padding()
            
        }
    }
}
