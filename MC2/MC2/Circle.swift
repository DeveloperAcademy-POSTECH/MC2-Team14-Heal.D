import SwiftUI

enum RingDiameter: CGFloat { // 원 중점 위치, 지름을 늘리고 줄이면서 원의 시작위치를 바꿈
    case small = 0.1
    case medium = 0.2
    case big = 0.3
    case calculated = 0.4
}

enum ColorType: String {
    case base
    case light
    case outline
}

//struct ActivityRing: View {
//    @Binding var progress: CGFloat
//
//    let ringDia: RingDiameter
//
//    private var fullCircleDotOffset: CGFloat { return 350 *  -ringDia.rawValue / 2 }
//    private let ringThickness: CGFloat = 15.0 // 두께
//
//    private var ringColor: [Color] {
//        get {
//            switch ringDia {
//            case .big: return [Color.darkRed,
//                               Color.lightRed,
//                               Color.lightRedCircleEnd,
//                               Color.outlineRed]
//            case .medium: return [Color.darkGreen,
//                                  Color.lightGreen,
//                                  Color.lightGreenCircleEnd,
//                                  Color.outlineGreen]
//            case .small: return [Color.darkBlue,
//                                 Color.lightBlue,
//                                 Color.lightBlueCircleEnd,
//                                 Color.outlineBlue]
//            default: return [Color.primary, Color.pink, Color.purple, Color.secondary]
//                
//            }
//        }
//    }
//
//    var body: some View {
//        ZStack {
//            if self.progress < 0.98 {
//                Circle()
//                    .scale(self.ringDia.rawValue)
//                    .stroke(self.ringColor[3], lineWidth: self.ringThickness)
//                Circle()
//                    .scale(self.ringDia.rawValue)
//                    .trim(from: 0, to: self.progress)
//                    .stroke(
//                        AngularGradient(
//                            gradient: Gradient(colors: [self.ringColor[0], self.ringColor[1]]),
//                            center: .center,
//                            startAngle: .degrees(0.0),
//                            endAngle: .init(degrees: 360.0)
//                        ),
//                        style: StrokeStyle(lineWidth: self.ringThickness, lineCap: .round))
//                    .rotationEffect(.degrees(-90.0))
//                Circle()
//                    .frame(width: self.ringThickness, height: self.ringThickness)
//                    .foregroundColor(self.ringColor[0])
//                    .offset(y: self.fullCircleDotOffset)
//
//            } else {
//                Circle()
//                    .scale(self.ringDia.rawValue)
//                    .stroke(
//                        AngularGradient(
//                            gradient: Gradient(colors: [self.ringColor[0], self.ringColor[1]]),
//                            center: .center,
//                            startAngle: .degrees(0.0),
//                            endAngle: .init(degrees: 360.0)
//                        ),
//                        style: StrokeStyle(lineWidth: self.ringThickness, lineCap: .round))
//                    .rotationEffect(.degrees((360 * Double(self.progress)) - 90))
//                Circle()
//                    .frame(width: self.ringThickness, height: self.ringThickness)
//                    .offset(y: self.fullCircleDotOffset)
//                    .foregroundColor(self.ringColor[2])
//                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: self.ringThickness / 4, y: 0)
//                    .rotationEffect(.degrees(360 * Double(self.progress)))
//            }
//        }
//        .frame(width: 350, height: 350)
//    }
//}
//
//struct ActivityRings: View {
//    @Binding var big: CGFloat
//    @Binding var medium: CGFloat
//    @Binding var small: CGFloat
//
//    var body: some View {
//        ZStack { // ring 끼리 겹쳐야 하므로 zstack 사용
//            ActivityRing(progress: self.$big, ringDia: .big)
//            ActivityRing(progress: self.$medium, ringDia: .medium)
//            ActivityRing(progress: self.$small, ringDia: .small)
//        }
//    }
//}
