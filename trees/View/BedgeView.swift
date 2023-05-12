//
//  dataBox.swift
//  trees
//
//  Created by 최진용 on 2023/05/08.
//

import SwiftUI

struct BedgeView: View {
    
    let colum = [GridItem(),GridItem(),GridItem(),GridItem()]
    let bedges: [String] = ["defaultOnOff", "bee", "bird", "butterfly", "dragon", "monkey", "parrot", "redDragon", "robusta", "sheep", "whiteBird"]
    
    @State var isLocked: Bool = true
    
    var body: some View {
        ScrollView {
                LazyVGrid(columns: colum) {
                    ForEach(bedges, id: \.self) { bedge in
                        RoundedRectangle(cornerRadius: 15)
                            .stroke()
                            .background(Color.random)
                            .cornerRadius(15)
                            .frame(height: 90)
                            .overlay(content: {
                                Image("\(bedge)").resizable()
                                    .scaledToFit()
                                    .padding()
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.gray)
                                // 코어데이터 딕셔너리나, 배열에 저장된 dimmed 상태에 따라서
                                    .opacity(isLocked ? 0 : 0.7)
                            })
//                            .foregroundColor(color)
                        //눌리면 현재 체크된건지 상태를 바꾸고, 코어데이터에 저장해서 나중에 불러올때 문제 없이 처리.
                            .overlay {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15).fill(Color.random)
                                        .opacity(0.6)
                                    LockImage
                                }
                            }
                            .onTapGesture {
                                print("\(bedge)")
                            }
                    }
                    //여기가 데이터 배열에서 lock인지 확인한 뒤, 락이라면 띄워주고 아니라면 없는 부분
                }.padding()
                    .padding(.top)
            }
        }
    
    var LockImage: some View {
        ZStack {
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                Image(systemName: "lock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width * 0.23)
                    .frame(width: width, height: height)
            }
            
        }
    }
    
}

struct BedgeView_Preview: PreviewProvider {
    static var previews: some View {
        BedgeView()
    }
}
