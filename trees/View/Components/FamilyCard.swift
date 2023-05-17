//
//  FamilyCard.swift
//  trees
//
//  Created by 최진용 on 2023/05/16.
//

import SwiftUI

struct FamilyCard: View {
    @StateObject var defaults: DefaultMission = DefaultMission()
    let familys: [User]
    @State private var totalNumberOfSteps = 0
    @State private var totalBurnedCalories = 0
    @State private var totalExerciseTime = 0
    @State var bigProgress: CGFloat = 0.0
    @State var mediumProgress: CGFloat = 0.0
    @State var smallProgress: CGFloat = 0.0
    @State private var isClicked: Bool = false
    
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
                    Text("걸음수 \(Int(defaults.totalWalk))/\(defaults.defaultWalk * familys.count)")
                        .foregroundColor(Color("lightRed"))
                        .font(.system(size: 14))
                    Text("칼로리 \(Int(defaults.totalCalories))/\(defaults.defaultCalories * familys.count)")
                        .foregroundColor(Color("lightGreen"))
                        .font(.system(size: 14))
                    Text("운동시간 \(Int(defaults.totalExerciseTime))/\(defaults.defaultExerciseTime * familys.count)")
                        .foregroundColor(Color("lightBlue"))
                        .font(.system(size: 14))
                    Spacer()
                }
                Spacer()
                HealthRing()
                    .environmentObject(defaults)
                    .frame(width: 40, height: 40)
                    .padding(.trailing, 30)
            }
            .onTapGesture {
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
            .onAppear {
                reloadData()
            }
            
            
        }
        
    }
    func resetForAnimation() {
        defaults.calculatedBigProgress = 0
        defaults.calculatedMediumProgress = 0
        defaults.calculatedSmallProgress = 0
    }
    
    private func reloadData() {
        totalNumberOfSteps = 0
        totalBurnedCalories = 0
        totalExerciseTime = 0
        
        defaults.totalWalk = 0
        defaults.totalCalories = 0
        defaults.totalExerciseTime = 0
        for family in familys {
            let health = family.healths?.first(where: { Calendar.current.dateComponents([.year, .month, .day], from:($0 as! Health).date!) == Calendar.current.dateComponents([.year, .month, .day], from: Date()) }) as! Health
            totalNumberOfSteps += Int(health.numberOfSteps > defaults.defaultWalk ? Int16(defaults.defaultWalk) : health.numberOfSteps)
            totalBurnedCalories += Int(health.burnedCalories > defaults.defaultCalories ? Int16(defaults.defaultCalories) : health.burnedCalories)
            totalExerciseTime += Int(health.exerciseTime > defaults.defaultExerciseTime ? Int16(defaults.defaultExerciseTime) : health.exerciseTime)
            
            
            defaults.totalWalk += Int(health.numberOfSteps)
            defaults.totalCalories += Int(health.burnedCalories)
            defaults.totalExerciseTime += Int(health.exerciseTime)
            

        }
        bigProgress = CGFloat(totalNumberOfSteps) / CGFloat(defaults.defaultWalk * familys.count)
        mediumProgress = CGFloat(totalBurnedCalories) / CGFloat(defaults.defaultCalories * familys.count)
        smallProgress = CGFloat(totalExerciseTime) / CGFloat(defaults.defaultExerciseTime * familys.count)
        
        defaults.calculatedBigProgress = CGFloat(defaults.totalWalk) / CGFloat(defaults.defaultWalk * familys.count)
        defaults.calculatedMediumProgress = CGFloat(defaults.totalCalories) / CGFloat(defaults.defaultCalories * familys.count)
        defaults.calculatedSmallProgress = CGFloat(defaults.totalExerciseTime) / CGFloat(defaults.defaultExerciseTime * familys.count)
    }
}
