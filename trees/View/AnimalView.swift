//
//  dataBox.swift
//  trees
//
//  Created by 최진용 on 2023/05/08.
//

import SwiftUI

struct AnimalView: View {
    @Environment(\.managedObjectContext) var viewContext
    @State private var reload: Bool = true
    
    let colum = [GridItem(),GridItem(),GridItem(),GridItem()]
    
    let user: User
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            ScrollView {
                Text(reload.description)
                    .opacity(0)
                LazyVGrid(columns: colum) {
                    ForEach(user.badges!, id: \.self) { badge in
                        RoundedRectangle(cornerRadius: 15)
                            .stroke()
                            .background((!badge.isLock && badge.isOn) ? .white : .gray)
                            .cornerRadius(15)
                            .frame(height: 90)
                            .overlay(content: {
                                Image("\(badge.name)").resizable()
                                    .brightness(badge.isLock ? -1 : 0)
                                    .scaledToFit()
                                    .padding()
                                // 코어데이터 딕셔너리나, 배열에 저장된 dimmed 상태에 따라서
                            })
                        //눌리면 현재 체크된건지 상태를 바꾸고, 코어데이터에 저장해서 나중에 불러올때 문제 없이 처리.
                            .onTapGesture {
                                if !badge.isLock {
                                    guard let changeIndex = user.badges?.firstIndex(where: {$0.name == badge.name}) else {return}
                                    
                                    badge.isOn.toggle()
                                    let newBadge = BadgeModel(
                                        name: badge.name,
                                        isOn: badge.isOn,
                                        isLock: badge.isLock
                                    )
                                    
                                    user.badges?.remove(at: changeIndex)
                                    user.badges?.insert(newBadge, at: changeIndex)
                                    
                                    try? viewContext.save()
                                    viewContext.refresh(user, mergeChanges: false)
                                    
                                    reload.toggle()
                                }
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
        AnimalView(user: User())
    }
}
