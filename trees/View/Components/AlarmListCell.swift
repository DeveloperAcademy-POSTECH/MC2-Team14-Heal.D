//
//  AlartListCell.swift
//  trees
//
//  Created by 최진용 on 2023/05/11.
//

import SwiftUI

struct AlarmListCell: View {
    var text: String
    var body: some View {
        HStack {
            Text("\(text)")
            Spacer()
            Button {
                print("ok")
            } label: {
                Text("수락")
                    .foregroundColor(.white)
            }.frame(width: 60, height: 30)
                .background(Color.accentColor)
                .cornerRadius(8)
            Button {
                print("cancle")
            } label: {
                Text("거절")
                    .foregroundColor(.white)
                    .background(Color.gray)
            }.frame(width: 60, height: 30)
                .background(Color.gray)
                .cornerRadius(8)
        }
    }
}

struct AlarmView_Preview: PreviewProvider {
    static var previews: some View {
        let text = "textwefniweofnwapqegnioqwbeo"
        AlarmListCell(text: text)
    }
}
