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
    @AppStorage("isFirst") var isFirst: Bool = true
    
    @StateObject var defaults: DefaultMission = DefaultMission()
    @State var showSheet: Bool = false
    @State var showAddAlert: Bool = false
    @State var showExitAlert: Bool = false
    @State var userName: String = ""
    
    let userId: String
    
    @FetchRequest
    var user: FetchedResults<User>
    
    init(userId: String) {
        _user = FetchRequest(
            entity: User.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "id == %@", userId)
        )
        self.userId = userId
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            Plant
            MileStone
            Buttons
            BottomSlider
        }
        .fullScreenCover(isPresented: $isFirst) {
            OnboardingView(isFirst: $isFirst, userId: userId)
                .environment(\.managedObjectContext, viewContext)
        }
    }


    
    //MARK: - Components
    var Plant: some View {
        Image("day" + String(user.first?.grow?.day ?? 1)).offset(y: 30)
    }
    
    var MileStone: some View {
        Image("milestone")
            .resizable()
            .frame(width: 109, height: 106)
            .offset(x:120, y: 115)
            .overlay {
                VStack{
                    Text(String(user.first?.grow?.day ?? 1) + "/30")
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
            ScrollViewReader { reader in
                ScrollView(.horizontal) {
                HStack(spacing: 5) {
                    if user.first?.familys?.count == 0 {
                        ForEach(-1...user.first!.familys!.count, id: \.self) { num in
                            GeometryReader { proxy in
                                let scale = getScale(proxy: proxy)
                                let endIdx = user.first?.familys?.count
                                if num == endIdx {
                                    AddPersonButton
                                        .scaleEffect(CGSize(width: scale, height: scale))
                                }
                                else if num ==  -1 {
                                    ExitFamilyButton
                                        .scaleEffect(CGSize(width: scale, height: scale))
                                }
                                else {
                                    HealthCard()
                                        .scaleEffect(CGSize(width: scale, height: scale))
                                }
                            }
                        }
                        .frame(width: 270, height: 140)
                        .padding(.trailing, 20)
                    }
                    else {
                        ForEach(-2...user.first!.familys!.count, id: \.self) { num in
                            GeometryReader { proxy in
                                let scale = getScale(proxy: proxy)
                                let endIdx = user.first?.familys?.count
                                if num == endIdx {
                                    AddPersonButton
                                        .scaleEffect(CGSize(width: scale, height: scale))
                                }
                                else if num ==  -2 {
                                    ExitFamilyButton
                                        .scaleEffect(CGSize(width: scale, height: scale))
                                }
                                else if num == -1 {
                                    FamilyCard().scaleEffect(CGSize(width: scale, height: scale))
                                }
                                else {
                                    HealthCard()
                                        .scaleEffect(CGSize(width: scale, height: scale))
                                }
                            }
                        }
                        .frame(width: 270, height: 140)
                        .padding(.trailing, 20)
                    }
                }
                .environmentObject(defaults)
                .padding(.leading, 60)
                .padding(.trailing, 40)
                .padding(.vertical, 30)
            }
                .onAppear {
                    if user.first?.familys?.count == 0 {
                        reader.scrollTo(0, anchor: .center)
                        print(user.first?.familys?.count)
                    } else {
                        reader.scrollTo(-1, anchor: .center)
                        print(user.first?.familys?.count)
                    }
                }
            }
        }
    }
    
    var ExitFamilyButton: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(Color("backgroundColor"))
            .overlay {
                Button {
                    showExitAlert.toggle()
                } label: {
                    VStack(spacing: 15) {
                        Image("ExitButton").resizable()
                            .scaledToFit()
                            .frame(width: 65)
                            .offset(x: -5)
                        Text("팀 탈퇴").foregroundColor(.red)
                            .font(.system(size: 15))
                    }
                }.alert("팀 탈퇴", isPresented: $showExitAlert) {
                    Button("OK", role: .destructive, action: {})
                } message: {
                    Text("그동안 얻은 모든것이 사라집니다. 정말 팀 탈퇴 하시겠습니까?")
                }
            }
    }
    
    //MARK: - 알람버튼 여기 이름 네트워킹으로 받아온거 넣기
    var AddPersonButton : some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(Color("backgroundColor"))
            .overlay {
                Button {
                    showAddAlert.toggle()
                } label: {
                    VStack(spacing: 15) {
                        Image("AddButton").resizable()
                            .scaledToFit()
                            .frame(width: 65)
                        Text("나의 초대코드 : 이름").foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                }
                //MARK: -여기에 func 밑에서 메소드로 만들어서 넣어주기
                .alert("팀 초대", isPresented: $showAddAlert) {
                    TextField("초대 코드를 입력해주세요", text: $userName)
                    Button("Cancel", role: .cancel, action: {})
                    Button("OK", action: {})
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
                        .frame(width: 35, height: 35)
                }.sheet(isPresented: $showSheet) {
                    AnimalView(user: user.first ?? User())
                        .environment(\.managedObjectContext, viewContext)
                        .presentationDetents([.fraction(0.4)])
                        .presentationDragIndicator(.visible)
                }
                Spacer()
                NavigationLink {
                    AlarmListView()
                } label: {
                    Image("alarmButton")
                        .resizable()
                        .frame(width: 30, height: 35)
                }
            }.padding()
            Spacer()
        }.padding(.horizontal)
    }
    
    //MARK: - Methods
    private func getScale(proxy: GeometryProxy) -> CGFloat {
        var scale: CGFloat = 0.8
        let x = proxy.frame(in: .global).minX - 35
        let diff = abs(x - 30)
        if diff < 200 {
            scale = 1 + (90 - diff) / 500
        }
        return scale
    }
}
