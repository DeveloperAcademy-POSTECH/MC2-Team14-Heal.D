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
