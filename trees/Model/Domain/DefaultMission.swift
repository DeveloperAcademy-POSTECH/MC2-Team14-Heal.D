//
//  DefaultMission.swift
//  test
//
//  Created by 최진용 on 2023/05/17.
//

import Foundation
import SwiftUI

enum RingDiameter: CaseIterable { // 원 중점 위치, 지름을 늘리고 줄이면서 원의 시작위치를 바꿈
    case big, medium, small, calculated
    
    var ringDiameter: CGFloat {
        switch self {
        case .big: return 0.28
        case .medium: return 0.18
        case .small: return 0.08
        case .calculated: return 0.4
        }
    }
    
    var ringColor: [Color] {
        switch self {
        case .big: return [Color("darkRed"),
                           Color("lightRed"),
                           Color("lightRedCircleEnd"),
                           Color("outlineRed")]
        case .medium: return [Color("darkGreen"),
                              Color("lightGreen"),
                              Color("lightGreenCircleEnd"),
                              Color("outlineGreen")]
        case .small: return [Color("darkBlue"),
                             Color("lightBlue"),
                             Color("lightBlueCircleEnd"),
                             Color("outlineBlue")]
        default: return [Color.primary, Color.pink, Color.purple, Color.secondary]
        }
    }
    var fullCircleDotOffset: CGFloat {
        switch self {
        case .big: return  350 *  -0.28 / 2
        case .medium:
            return 350 *  -0.18 / 2
        case .small:
            return 350 *  -0.08 / 2
        case .calculated:
            return 350 *  -0.4 / 2
        }
    }
    var ringThickness: CGFloat { return 14.3 }
}


class DefaultMission: ObservableObject {
    let defaultWalk: Int = 3000
    let defaultCalories: Int = 300
    let defaultExerciseTime: Int = 30
    
    @Published var calculatedBigProgress: CGFloat = 0
    @Published var calculatedMediumProgress: CGFloat = 0
    @Published var calculatedSmallProgress: CGFloat = 0
    
    @Published var totalWalk: Int = 0
    @Published var totalCalories: Int = 0
    @Published var totalExerciseTime: Int = 0

    let ringSetting: [RingDiameter] = RingDiameter.allCases
}
