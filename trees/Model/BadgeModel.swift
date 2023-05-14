//
//  BadgeModel.swift
//  trees
//
//  Created by 조기연 on 2023/05/15.
//

import Foundation
import CoreData

public class BadgeModel: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    init(name: String = "", isOn: Bool = false, isLock: Bool = false) {
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
    var isOn: Bool = false
    var isLock = false
}


extension BadgeModel {
    static let names: [String] = [
        "bee",
        "bird",
        "butterfly",
        "dragon",
        "monkey",
        "parrot",
        "redDragon",
        "robusta",
        "sheep",
        "whiteBird",
    ]
}
