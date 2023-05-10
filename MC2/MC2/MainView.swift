//
//  MainView.swift
//  MC2
//
//  Created by 송재훈 on 2023/05/09.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        Image("Ground1")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
