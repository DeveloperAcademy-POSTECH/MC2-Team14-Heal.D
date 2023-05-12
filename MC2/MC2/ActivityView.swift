//
//  ActivityView.swift
//  MC2
//
//  Created by 송재훈 on 2023/05/12.
//

import SwiftUI

struct ActivityView: View {
    @StateObject var viewModel = ContentViewModel()
    
    @State private var progressBig: CGFloat = 1.0
    @State private var progressMedium: CGFloat = 1.0
    @State private var progressSmall: CGFloat = 1.0
    
    @State var array: [Int] = [1,2,3,3,4,5,2,3,4,5]
    
    var body: some View {
        ZStack() {
            BottomSlider
        }
    }
    
    var BottomSlider: some View {
        VStack {
            Spacer()
            ScrollView(.horizontal) {
                HStack(spacing: 5) {
                    ForEach(0...array.count, id: \.self) { num in
                        GeometryReader { proxy in
                            let x = proxy.frame(in: .global).minX
                            let scale = getScale(proxy: proxy)
                            let endIdx = array.endIndex
                            if num == endIdx {
                                //인원추가 버튼
                                Rectangle()
                                    .foregroundColor(.blue)
                                    .frame(width: 270, height: 140)
                                    .padding(.leading, 15)
                                    .scaleEffect(CGSize(width: scale, height: scale))
                            } else {
                                //헬스킷 데이터 뷰
                                Rectangle()
                                    .foregroundColor(.red)
                                    .frame(width: 270, height: 140)
                                    .padding(.leading, 20)
                                    .scaleEffect(CGSize(width: scale, height: scale))
                                    .overlay {
                                        ActivityRings(big: $progressBig, medium: $progressMedium, small: $progressSmall)
                                            .scaleEffect(CGSize(width: scale, height: scale))
                                    }
                            }
                        }
                    }
                    .frame(width: 270, height: 140)
                    .padding(.trailing, 20)
                }
                .padding(.horizontal, 50)
                .padding(.vertical, 30)
            }
            .scrollIndicators(.never)
        }
    }
    
    private func getScale(proxy: GeometryProxy) -> CGFloat {
        var scale: CGFloat = 0.8
        let x = proxy.frame(in: .global).minX
        let diff = abs(x - 30)
        if diff < 200 {
            scale = 1 + (90 - diff) / 500
        }
        return scale
    }
}

struct ActivityRing: View {
    @Binding var progress: CGFloat

    let ringDia: RingDiameter

    private var fullCircleDotOffset: CGFloat { return 350 *  -ringDia.rawValue / 2 }
    private let ringThickness: CGFloat = 15.0 // 두께

    private var ringColor: [Color] {
        get {
            switch ringDia {
            case .big: return [Color.darkRed,
                               Color.lightRed,
                               Color.lightRedCircleEnd,
                               Color.outlineRed]
            case .medium: return [Color.darkGreen,
                                  Color.lightGreen,
                                  Color.lightGreenCircleEnd,
                                  Color.outlineGreen]
            case .small: return [Color.darkBlue,
                                 Color.lightBlue,
                                 Color.lightBlueCircleEnd,
                                 Color.outlineBlue]
            default: return [Color.primary, Color.pink, Color.purple, Color.secondary]
                
            }
        }
    }

    var body: some View {
        ZStack {
            if self.progress < 0.98 {
                Circle()
                    .scale(self.ringDia.rawValue)
                    .stroke(self.ringColor[3], lineWidth: self.ringThickness)
                Circle()
                    .scale(self.ringDia.rawValue)
                    .trim(from: 0, to: self.progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [self.ringColor[0], self.ringColor[1]]),
                            center: .center,
                            startAngle: .degrees(0.0),
                            endAngle: .init(degrees: 360.0)
                        ),
                        style: StrokeStyle(lineWidth: self.ringThickness, lineCap: .round))
                    .rotationEffect(.degrees(-90.0))
                Circle()
                    .frame(width: self.ringThickness, height: self.ringThickness)
                    .foregroundColor(self.ringColor[0])
                    .offset(y: self.fullCircleDotOffset)

            } else {
                Circle()
                    .scale(self.ringDia.rawValue)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [self.ringColor[0], self.ringColor[1]]),
                            center: .center,
                            startAngle: .degrees(0.0),
                            endAngle: .init(degrees: 360.0)
                        ),
                        style: StrokeStyle(lineWidth: self.ringThickness, lineCap: .round))
                    .rotationEffect(.degrees((360 * Double(self.progress)) - 90))
                Circle()
                    .frame(width: self.ringThickness, height: self.ringThickness)
                    .offset(y: self.fullCircleDotOffset)
                    .foregroundColor(self.ringColor[2])
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: self.ringThickness / 4, y: 0)
                    .rotationEffect(.degrees(360 * Double(self.progress)))
            }
        }
        .frame(width: 350, height: 350)
    }
}

struct ActivityRings: View {
    @Binding var big: CGFloat
    @Binding var medium: CGFloat
    @Binding var small: CGFloat

    var body: some View {
        ZStack { // ring 끼리 겹쳐야 하므로 zstack 사용
            ActivityRing(progress: self.$big, ringDia: .big)
            ActivityRing(progress: self.$medium, ringDia: .medium)
            ActivityRing(progress: self.$small, ringDia: .small)
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
