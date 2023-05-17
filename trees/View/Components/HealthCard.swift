//
//  HealthCard.swift
//  trees
//
//  Created by 최진용 on 2023/05/11.
//

import SwiftUI

struct HealthCard: View {
    let user: User?
    let healthData: Health?

    @StateObject var defaultMission: DefaultMission = DefaultMission()
    @State var isClicked: Bool = false

    
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
                    Text("걸음수 \((healthData?.numberOfSteps ?? 0) > defaultMission.defaultWalk ? Int16(defaultMission.defaultWalk) : (healthData?.numberOfSteps ?? 0))/\(defaultMission.defaultWalk)")
                        .foregroundColor(Color("lightRed"))
                        .font(.system(size: 14))
                    Text("칼로리 \((healthData?.burnedCalories ?? 0) > defaultMission.defaultCalories ? Int16(defaultMission.defaultCalories) : (healthData?.burnedCalories ?? 0))/\(defaultMission.defaultCalories)")
                        .foregroundColor(Color("lightGreen"))
                        .font(.system(size: 14))
                    Text("운동시간 \((healthData?.exerciseTime ?? 0) > defaultMission.defaultExerciseTime ? Int16(defaultMission.defaultExerciseTime) : (healthData?.exerciseTime ?? 0))/\(defaultMission.defaultExerciseTime)")
                        .foregroundColor(Color("lightBlue"))
                        .font(.system(size: 14))
                    Spacer()
                }
                Spacer()
                HealthRing()
                    .environmentObject(defaultMission)
                    .frame(width: 40, height: 40)
                    .padding(.trailing, 30)
            }.onTapGesture {
                resetForAnimation()
                withAnimation(.easeInOut(duration: 0.2)) {
                    isClicked = true
                }
            }.onChange(of: isClicked, perform: { _ in
                if isClicked {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isClicked = false
                    }
                    withAnimation(.easeOut(duration: 1)) {
                        reloadData()
                    }
                }
            })
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 15).foregroundColor(.white).opacity(isClicked ? 0.4 : 0)
            }
        }
    }
    
    func reloadData() {
        defaultMission.calculatedBigProgress = CGFloat((healthData?.numberOfSteps ?? 0) > defaultMission.defaultWalk ? Int16(defaultMission.defaultWalk) : (healthData?.numberOfSteps ?? 0)) / CGFloat(defaultMission.defaultWalk)
        defaultMission.calculatedMediumProgress  = CGFloat((healthData?.burnedCalories ?? 0) > defaultMission.defaultCalories ? Int16(defaultMission.defaultCalories) : (healthData?.burnedCalories ?? 0)) / CGFloat(defaultMission.defaultCalories)
        defaultMission.calculatedSmallProgress  = CGFloat((healthData?.exerciseTime ?? 0) > defaultMission.defaultExerciseTime ? Int16(defaultMission.defaultExerciseTime) : (healthData?.exerciseTime ?? 0)) / CGFloat(defaultMission.defaultExerciseTime)
    }
    func resetForAnimation() {
        defaultMission.calculatedBigProgress = 0
        defaultMission.calculatedMediumProgress = 0
        defaultMission.calculatedSmallProgress = 0
    }
}
