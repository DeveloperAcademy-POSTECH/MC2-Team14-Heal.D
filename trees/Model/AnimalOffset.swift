//
//  AnimalOffset.swift
//  trees
//
//  Created by 송재훈 on 2023/05/16.
//

import Foundation

import SwiftUI

class AnimalOffset: ObservableObject {
    let animalOffset: [(animalName: String, offset: CGSize)] = [
        ("bee", CGSize(width: 50, height: 0)),
        ("bird", CGSize(width: 100, height: -150)),
        ("butterfly", CGSize(width: -50, height: -50)),
        ("dragon", CGSize(width: 100, height: 200)),
        ("monkey", CGSize(width: -100, height: 100)),
        ("parrot", CGSize(width: 0, height: 0)),
        ("redDragon", CGSize(width: -100, height: -150)),
        ("robusta", CGSize(width: 50, height: 150)),
        ("sheep", CGSize(width: -100, height: 100)),
        ("whiteBird", CGSize(width: -50, height: 100))
    ]
}
