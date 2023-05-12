//
//  HealthCard.swift
//  trees
//
//  Created by 최진용 on 2023/05/11.
//

import SwiftUI

struct HealthCard: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("이름")
                Text("walk")
                Text("calories")
                Text("time")
            }
            Spacer()
            Rectangle().frame(width: 80, height: 80)
        }.padding()
    }
}

struct CardView_Preview: PreviewProvider {
    static var previews: some View {
        HealthCard()
    }
}
