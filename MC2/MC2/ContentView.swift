//
//  ContentView.swift
//  MC2
//
//  Created by 송재훈 on 2023/05/07.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                BackgroundView()
                ActivityView()
                ButtonView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
