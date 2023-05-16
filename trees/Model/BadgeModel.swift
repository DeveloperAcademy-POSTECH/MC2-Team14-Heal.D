//
//  BadgeModel.swift
//  trees
//
//  Created by 조기연 on 2023/05/15.
//

import Foundation
import CoreData
import SwiftUI

enum Animal: CaseIterable {
    case redDragon, bird, robusta, butterfly, dragon, monkey, parrot, bee, sheep, whiteBird
    
    var name: String {
        switch self {
        case .bee: return "bee"
        case .bird: return "bird"
        case .butterfly: return "butterfly"
        case .dragon: return "dragon"
        case .monkey: return "monkey"
        case .parrot: return "parrot"
        case .redDragon: return "redDragon"
        case .robusta: return "robusta"
        case .sheep: return "sheep"
        case .whiteBird: return "whiteBird"
        }
    }
    
    var offset: CGSize {
        switch self {
        case .bee: return CGSize(width: 50, height: 0)
        case .bird: return CGSize(width: 100, height: -150)
        case .butterfly: return CGSize(width: -50, height: -50)
        case .dragon: return CGSize(width: 80, height: -300)
        case .monkey: return CGSize(width: -50, height: 100)
        case .parrot: return CGSize(width: 160, height: 90)
        case .redDragon: return CGSize(width: -100, height: -170)
        case .robusta: return CGSize(width: -120, height: 50)
        case .sheep: return CGSize(width: -140, height: 120)
        case .whiteBird: return CGSize(width: 30, height: 110)
        }
    }
    
    var widthSize: CGFloat {
        switch self {
        case .bee: return CGFloat(40)
        case .bird: return CGFloat(60)
        case .butterfly: return CGFloat(40)
        case .dragon: return CGFloat(80)
        case .monkey: return CGFloat(60)
        case .parrot: return CGFloat(60)
        case .redDragon: return CGFloat(100)
        case .robusta: return CGFloat(60)
        case .sheep: return CGFloat(70)
        case .whiteBird: return CGFloat(60)
        }
    }
    
    var heightSize: CGFloat {
        switch self {
        case .bee: return CGFloat(40)
        case .bird: return CGFloat(60)
        case .butterfly: return CGFloat(40)
        case .dragon: return CGFloat(120)
        case .monkey: return CGFloat(60)
        case .parrot: return CGFloat(100)
        case .redDragon: return CGFloat(100)
        case .robusta: return CGFloat(50)
        case .sheep: return CGFloat(70)
        case .whiteBird: return CGFloat(80)
        }
    }
}

public class BadgeModel: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    init(name: String = "", isOn: Bool = false, isLock: Bool = true) {
        self.name = name
        self.isOn = isOn
        self.isLock = isLock
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(isOn, forKey: "isOn")
        coder.encode(isLock, forKey: "isLock")
        coder.encode(name, forKey: "name")
    }
    
    public required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: "name") as! String
        self.isOn = coder.decodeBool(forKey: "isOn")
        self.isLock = coder.decodeBool(forKey: "isLock")
    }
    
    var name = ""
    var isOn = false
    var isLock = true
}

extension BadgeModel {
    
    static let animals: [Animal] = Animal.allCases
}


struct AnimalTest: View {
    @State var isAnimation: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            Plant
            MileStone
            ani
        }
    }
    
    var ani: some View {
        ZStack {
            ForEach(BadgeModel.animals, id: \.self) { animal in
                Image("\(animal.name)0").resizable()
                    .offset(animal.offset)
                    .frame(width: animal.widthSize, height: animal.heightSize)
            }.opacity(isAnimation ? 1 : 0)
            ForEach(BadgeModel.animals, id: \.self) { animal in
                Image("\(animal.name)1").resizable()
                    .offset(animal.offset)
                    .frame(width: animal.widthSize, height: animal.heightSize)
            }.opacity(isAnimation ? 0 : 1)
        }.onAppear {
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {  _ in
                isAnimation.toggle()
            }
        }
    }
    
    var Plant: some View {
        Image("day" + String(1)).offset(y: 30)
    }
    
    var MileStone: some View {
        Image("milestone")
            .resizable()
            .frame(width: 109, height: 106)
            .offset(x:120, y: 115)
            .overlay {
                VStack{
                    Text(String(1) + "/30")
                        .foregroundStyle(
                            .white.gradient
                                .shadow(.inner(color: .black, radius: 0, x: 1, y: 1))
                        )
                }.font(.system(size: 16, weight: .black))
                    .offset(x: 104, y: 102)
                    .rotationEffect(Angle(degrees: -4))
            }
    }
}

struct AnimalTest_Previews: PreviewProvider {
    static var previews: some View {
        AnimalTest()
    }
}
