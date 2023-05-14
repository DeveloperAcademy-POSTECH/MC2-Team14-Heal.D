//
//  dataBox.swift
//  trees
//
//  Created by 최진용 on 2023/05/08.
//

import SwiftUI

struct AnimalView: View {
    let colum = [GridItem(),GridItem(),GridItem(),GridItem()]
    let animals: [String] = ["defaultOnOff", "bee", "bird", "butterfly", "dragon", "monkey", "parrot", "redDragon", "robusta", "sheep", "whiteBird"]
    
    @State var isLocked: Bool = true
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            ScrollView {
                LazyVGrid(columns: colum) {
                    ForEach(animals, id: \.self) { animal in
                        RoundedRectangle(cornerRadius: 15)
                            .stroke()
                            .background(isLocked ? .gray : .white)
                            .cornerRadius(15)
                            .frame(height: 90)
                            .overlay(content: {
                                Image("\(animal)").resizable()
                                    .brightness(isLocked ? -1 : 0)
                                    .scaledToFit()
                                    .padding()
                                // 코어데이터 딕셔너리나, 배열에 저장된 dimmed 상태에 따라서
                            })
                        //눌리면 현재 체크된건지 상태를 바꾸고, 코어데이터에 저장해서 나중에 불러올때 문제 없이 처리.
                            .onTapGesture {
                                print("\(animal)")
                            }
                    }
                    //여기가 데이터 배열에서 lock인지 확인한 뒤, 락이라면 띄워주고 아니라면 없는 부분
                }.padding()
                    .padding(.top)
            }
        }
    }
}

struct AnimalView_Preview: PreviewProvider {
    static var previews: some View {
        AnimalView()
    }
}
