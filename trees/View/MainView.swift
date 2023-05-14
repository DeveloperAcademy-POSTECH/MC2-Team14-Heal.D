//
//  ContentView.swift
//  trees
//
//  Created by 최진용 on 2023/05/08.
//

import SwiftUI
import CoreData

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var showSheet: Bool = false
    @State var array: [Int] = [1,2,3,3,4,5,2,3,4,5]
    
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: []
    )
    var user: FetchedResults<User>
    
    var body: some View {
        ZStack {
            BackgroundView()
            Plant
            MileStone
            Buttons
            BottomSlider
        }
    }
    
    //MARK: - components
    var Plant: some View {
        Image("day" + String(user.first!.grow!.day)).offset(y: 30)
    }
    
    var MileStone: some View {
        Image("milestone")
            .resizable()
            .frame(width: 109, height: 106)
            .offset(x:120, y: 115)
            .overlay {
                VStack{
                    Text(String(user.first!.grow!.day) + "/30")
                        .foregroundStyle(
                            .white.gradient
                                .shadow(.inner(color: .black, radius: 0, x: 1, y: 1))
                        )
                }.font(.system(size: 16, weight: .black))
                    .offset(x: 104, y: 102)
                    .rotationEffect(Angle(degrees: -4))
            }
    }
    
    
    var BottomSlider: some View {
        VStack {
            Spacer()
            ScrollView(.horizontal) {
                HStack(spacing: 5) {
                    ForEach(0...user.first!.familys!.count, id: \.self) { num in
                        GeometryReader { proxy in
                            let scale = getScale(proxy: proxy)
                            let endIdx = array.endIndex
                            if num == endIdx {
                                Rectangle()
                            } else {
                                HealthCard()
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
                    Image("animalButton")
                        .resizable()
                        .frame(width: 51, height: 50)
                }.sheet(isPresented: $showSheet) {
                    AnimalView(badge: user.first!.badge!)
                        .presentationDetents([.fraction(0.4)])
                        .presentationDragIndicator(.visible)
                }
                Spacer()
                NavigationLink {
                    AlarmListView()
                } label: {
                    Image("alarmButton")
                        .resizable()
                        .frame(width: 45, height: 50)
                }
            }.padding()
            Spacer()
        }.padding(.horizontal)
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
