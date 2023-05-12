//
//  AlartListView.swift
//  trees
//
//  Created by 최진용 on 2023/05/11.
//

import SwiftUI



struct AlartListView: View {
    
    var data: [String] = []
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            ScrollView {
                VStack {
                    if data.isEmpty {
                        Text("hi").frame(width: width, height: height)
                    } else {
                        ForEach(data, id: \.self) { text in
                            AlartListCell(text: text)
                            Divider()
                        }
                    }
                }
            }
        }.padding()
    }
}

struct AlartListView_Preview: PreviewProvider {
    static var previews: some View {
        AlartListView()
    }
}
