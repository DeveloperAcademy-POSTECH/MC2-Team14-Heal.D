//
//  ContentView.swift
//  trees
//
//  Created by 최진용 on 2023/05/08.
//

import SwiftUI
import CoreData

struct MainView: View {
    @State var showSheet: Bool = false
    @State var array: [Int] = [1,2,3,3,4,5,2,3,4,5]
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                Buttons
                BottomSlider
            }
        }
    }
    var BottomSlider: some View {
        VStack {
            Spacer()
            ScrollView(.horizontal) {
                HStack(spacing: 5) {
                    ForEach(0...array.count, id: \.self) { num in
                        GeometryReader { proxy in
                            let x = proxy.frame(in: .global).minX
                            let scale = getScale(proxy: proxy)
                            let endIdx = array.endIndex
                            if num == endIdx {
                                //인원추가 버튼
                                Rectangle().foregroundColor(.blue)
                                    .frame(width: 270, height: 140)
                                    .padding(.leading, 15)
//                                            .padding(.trailing, 200)
                                    .scaleEffect(CGSize(width: scale, height: scale))
                            } else {
                                //헬스킷 데이터 뷰
                                Rectangle().foregroundColor(.red)
                                    .frame(width: 270, height: 140)
                                    .padding(.leading, 20)
                                    .scaleEffect(CGSize(width: scale, height: scale))
                            }
                         }
                    }
                    .frame(width: 270, height: 140)
                    .padding(.trailing, 20)
                }
                .padding(.horizontal, 50)
                    .padding(.vertical, 30)
            }
        }
    }
    
    
    var Buttons: some View {
        VStack {
            HStack {
                Button {
                    showSheet.toggle()
                } label: {
                    Rectangle().frame(width: 40, height: 40)
                }.sheet(isPresented: $showSheet) {
                    BedgeView()
                        .presentationDetents([.fraction(0.4)])
                        .presentationDragIndicator(.visible)
                }
                Spacer()
                NavigationLink {
                    AlartListView()
                } label: {
                    Rectangle().frame(width: 40, height: 40)
                }
            }.padding()
            Spacer()
        }
    }
    
    private func getScale(proxy: GeometryProxy) -> CGFloat {
        var scale: CGFloat = 0.8
        let x = proxy.frame(in: .global).minX
        let diff = abs(x - 30)
        if diff < 200 {
            scale = 1 + (90 - diff) / 500
        }
        return scale
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
