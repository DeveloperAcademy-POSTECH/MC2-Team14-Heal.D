//
//  HealthRing.swift
//  test
//
//  Created by 최진용 on 2023/05/17.
//

import Foundation
import SwiftUI

struct HealthRing: View {
    
    @EnvironmentObject var ringSetting: DefaultMission
    
    var body: some View {
        ZStack { // ring 끼리 겹쳐야 하므로 zstack 사용
            ring1
            ring2
            ring3
        }
    }
    var ring1: some View {
        ZStack {
            Circle()
                .scale(ringSetting.ringSetting[0].ringDiameter)
                .stroke(ringSetting.ringSetting[0].ringColor[3], lineWidth: ringSetting.ringSetting[0].ringThickness)
            Circle()
                .scale(ringSetting.ringSetting[0].ringDiameter)
                .trim(from: 0, to: ringSetting.calculatedBigProgress  > 1.0 ? 1.0 : ringSetting.calculatedBigProgress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [ringSetting.ringSetting[0].ringColor[0], ringSetting.ringSetting[0].ringColor[1]]),
                        center: .center,
                        startAngle: .degrees(0.0),
                        endAngle: .init(degrees: 360.0)
                    ),
                    style: StrokeStyle(lineWidth: ringSetting.ringSetting[0].ringThickness, lineCap: .round))
                .rotationEffect(.degrees(-90.0))
            Circle()
                .frame(width: ringSetting.ringSetting[0].ringThickness, height: ringSetting.ringSetting[0].ringThickness)
                .foregroundColor(ringSetting.ringSetting[0].ringColor[0])
                .offset(y: ringSetting.ringSetting[0].fullCircleDotOffset)
        }
        .frame(width: 350, height: 350)
    }
    
    var ring2: some View {
        ZStack {
            Circle()
                .scale(ringSetting.ringSetting[1].ringDiameter)
                .stroke(ringSetting.ringSetting[1].ringColor[3], lineWidth: ringSetting.ringSetting[1].ringThickness)
            Circle()
                .scale(ringSetting.ringSetting[1].ringDiameter)
                .trim(from: 0, to: ringSetting.calculatedMediumProgress > 1.0 ? 1.0 : ringSetting.calculatedMediumProgress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [ringSetting.ringSetting[1].ringColor[0], ringSetting.ringSetting[1].ringColor[1]]),
                        center: .center,
                        startAngle: .degrees(0.0),
                        endAngle: .init(degrees: 360.0)
                    ),
                    style: StrokeStyle(lineWidth: ringSetting.ringSetting[1].ringThickness, lineCap: .round))
                .rotationEffect(.degrees(-90.0))
            Circle()
                .frame(width: ringSetting.ringSetting[1].ringThickness, height: ringSetting.ringSetting[1].ringThickness)
                .foregroundColor(ringSetting.ringSetting[1].ringColor[0])
                .offset(y: ringSetting.ringSetting[1].fullCircleDotOffset)
        }
        .frame(width: 350, height: 350)
    }
    var ring3: some View {
        ZStack {
            Circle()
                .scale(ringSetting.ringSetting[2].ringDiameter)
                .stroke(ringSetting.ringSetting[2].ringColor[3], lineWidth: ringSetting.ringSetting[2].ringThickness)
            Circle()
                .scale(ringSetting.ringSetting[2].ringDiameter)
                .trim(from: 0, to: ringSetting.calculatedSmallProgress > 1.0 ? 1.0 : ringSetting.calculatedSmallProgress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [ringSetting.ringSetting[2].ringColor[0], ringSetting.ringSetting[2].ringColor[1]]),
                        center: .center,
                        startAngle: .degrees(0.0),
                        endAngle: .init(degrees: 360.0)
                    ),
                    style: StrokeStyle(lineWidth: ringSetting.ringSetting[2].ringThickness, lineCap: .round))
                .rotationEffect(.degrees(-90.0))
            Circle()
                .frame(width: ringSetting.ringSetting[2].ringThickness, height: ringSetting.ringSetting[2].ringThickness)
                .foregroundColor(ringSetting.ringSetting[2].ringColor[0])
                .offset(y: ringSetting.ringSetting[2].fullCircleDotOffset)
        }
        .frame(width: 350, height: 350)
    }
}


