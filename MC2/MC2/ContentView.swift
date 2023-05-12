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
                let geoWidth = geo.size.width
                let geoHeight = geo.size.height
                
                BackgroundView()
                ActivityView()
                ButtonView()
                //                SnapCarousel()
                //                    .environmentObject(viewModel.stateModel)
                //                    .frame(height: geoHeight * 0.3)
                //                    .frame(maxHeight: .infinity, alignment: .bottom)
                //                    .ignoresSafeArea()
                //                    .onAppear {
                //                        //                        HealthAuth()
                //
                //            }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
