//
//  Clouds.swift
//  trees
//
//  Created by 최진용 on 2023/05/10.
//

import SwiftUI

struct Clouds: View {
    var body: some View {
        ZStack {
            Image("Cloud")
                .resizable()
                .aspectRatio(contentMode: .fill)
            Image("Cloud")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}
