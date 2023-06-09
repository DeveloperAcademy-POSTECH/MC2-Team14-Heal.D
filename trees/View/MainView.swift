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
    
    @StateObject var healthData: HealthData = HealthData()
    @StateObject var defaultMission: DefaultMission = DefaultMission()
    @State private var showSheet: Bool = false
    @State private var showAddAlert: Bool = false
    @State private var showExitAlert: Bool = false
    @State private var inviteCode: String = ""
    @State private var isLoading: Bool = true
    @Binding var userId: String
    
    //state일 필요없지않나?
    @State private var user: User?
    @State private var coreDataHealth: Health?
    
    @State private var dataReset: Bool = false
    @State private var isAnimation = false
    @State private var isAnimalMove = false
    @State private var animationTimer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        if isFirst {
            OnboardingView(healthData: healthData, isFirst: $isFirst, isAnimation: $isAnimation, userId: $userId)
                .environment(\.managedObjectContext, viewContext)
                .transition(.opacity)
                .animation(.linear(duration: 0.5), value: isFirst)
                .onAppear {
                    isAnimation.toggle()
                }
        }
        else {
            ZStack {
                BackgroundView(isAnimation: $isAnimation)
                Plant
                MileStone
                Buttons
                BottomSlider
                Animals
            }.overlay {
                LaunchingScreen
                    .onAppear {
                    isAnimation.toggle()
                }
            }.onChange(of: isLoading) { _ in
                configureAllSetting()
                
            }.onAppear {
                isAnimation.toggle()
                resetForAnimation()
                withAnimation(.easeIn(duration: 1)) {
                    reloadData()
                }
            }
        }
    }
    
    
    
    //MARK: - Components
    var Animals: some View {
        ZStack {
            ForEach(0..<BadgeModel.animals.count, id: \.self) { idx in
                Image("\(BadgeModel.animals[idx].name)0").resizable()
                    .offset(BadgeModel.animals[idx].offset)
                    .frame(width: BadgeModel.animals[idx].widthSize, height: BadgeModel.animals[idx].heightSize)
                    .opacity((user?.badges![idx].isOn == true) ? 1 : 0)
            }.opacity(isAnimalMove ? 1 : 0)
            ForEach(0..<BadgeModel.animals.count, id: \.self) { idx in
                Image("\(BadgeModel.animals[idx].name)1").resizable()
                    .offset(BadgeModel.animals[idx].offset)
                    .frame(width: BadgeModel.animals[idx].widthSize, height: BadgeModel.animals[idx].heightSize)
                    .opacity((user?.badges![idx].isOn == true) ? 1 : 0)
            }.opacity(isAnimalMove ? 0 : 1)
        }.onReceive(animationTimer) { _ in
            isAnimalMove.toggle()
        }
    }
    
    
    var LaunchingScreen: some View {
        ZStack {
            BackgroundView(isAnimation: $isAnimation)
            Image("onboardingTitle")
        }.ignoresSafeArea()
            .opacity(isLoading ? 1 : 0)
            .onAppear {
                isAnimation.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.linear(duration: 0.4)) {
                        isLoading = false
                    }
                }
            }
    }
    
    
    var Plant: some View {
        Image("day" + String(user?.grow?.day ?? 1)).offset(y: 30)
    }
    
    var MileStone: some View {
        Image("milestone")
            .resizable()
            .frame(width: 109, height: 106)
            .offset(x:120, y: 115)
            .overlay {
                VStack{
                    Text(String(user?.grow?.day ?? 1) + "/30")
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
                        if (user?.familys?.count == 1) {
                            ForEach(0...1, id: \.self) { num in
                                GeometryReader { proxy in
                                    let scale = getScale(proxy: proxy)
                                    if num == 1 {
                                        AddPersonButton
                                            .scaleEffect(CGSize(width: scale, height: scale))
                                    }
                                    else {
                                        HealthCard(user: (user?.familys?.allObjects as! [User])[num], healthData: (user?.familys?.allObjects as! [User])[num].healths?.first(where: { Calendar.current.dateComponents([.year, .month, .day], from:($0 as! Health).date!) == Calendar.current.dateComponents([.year, .month, .day], from: Date()) }) as? Health)
                                            .scaleEffect(CGSize(width: scale, height: scale))
                                            .onAppear {
                                                resetForAnimation()
                                                if user?.familys?.count == 1 {
                                                    reader.scrollTo(0, anchor: .center)
                                                } else {
                                                    reader.scrollTo(-1, anchor: .center)
                                                }
                                                withAnimation(.easeIn(duration: 1)) {
                                                    reloadData()
                                                }
                                            }
                                    }
                                }
                            }
                            .frame(width: 270, height: 140)
                            .padding(.trailing, 20)
                        }
                        else {
                            ForEach(-2...(user?.familys?.count ?? -2), id: \.self) { num in
                                GeometryReader { proxy in
                                    let scale = getScale(proxy: proxy)
                                    let endIdx = user?.familys?.count
                                    if num == endIdx {
                                        AddPersonButton
                                            .scaleEffect(CGSize(width: scale, height: scale))
                                    }
                                    else if num == -2 {
                                        ExitFamilyButton
                                            .scaleEffect(CGSize(width: scale, height: scale))
                                    }
                                    else if num == -1 {
                                        FamilyCard(familys: user?.familys?.allObjects as! [User])
                                            .scaleEffect(CGSize(width: scale, height: scale))
                                    }
                                    else {
                                        HealthCard(user: (user?.familys?.allObjects as! [User])[num], healthData: (user?.familys?.allObjects as! [User])[num].healths?.first(where: { Calendar.current.dateComponents([.year, .month, .day], from:($0 as! Health).date!) == Calendar.current.dateComponents([.year, .month, .day], from: Date()) }) as? Health)
                                            .scaleEffect(CGSize(width: scale, height: scale))
                                            .onAppear {
                                                resetForAnimation()
                                                if user?.familys?.count == 1 {
                                                    reader.scrollTo(0, anchor: .center)
                                                } else {
                                                    reader.scrollTo(-1, anchor: .center)
                                                }
                                                withAnimation(.easeIn(duration: 1)) {
                                                    reloadData()
                                                }
                                            }
                                    }
                                }
                            }
                            .frame(width: 270, height: 140)
                            .padding(.trailing, 20)
                        }
                    }
                    .padding(.leading, 60)
                    .padding(.trailing, 40)
                    .padding(.vertical, 30)
                }.scrollIndicators(.hidden)
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
                    Button("OK", role: .destructive, action: {
                        if let user = user {
                            user.familys = NSSet()
                            user.addToFamilys(user)
                            try? viewContext.save()
                            viewContext.refresh(user, mergeChanges: false)
                        }
                        isAnimation.toggle()
                    })
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
                        Text("나의 초대코드 : \(user?.code ?? "None")").foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                }
                //MARK: -여기에 func 밑에서 메소드로 만들어서 넣어주기
                .alert("팀 초대", isPresented: $showAddAlert) {
                    TextField("초대 코드를 입력해주세요", text: $inviteCode)
                    Button("Cancel", role: .cancel, action: {
                        isAnimation.toggle()
                    })
                    Button("OK", action: {
                        var invitee: User? = nil
                        viewContext.performAndWait {
                            let request = User.fetchRequest()
                            request.predicate = NSPredicate(format: "code == %@", inviteCode)
                            invitee = try? viewContext.fetch(request).first
                        }
                        if let invitee = invitee {
                            invitee.addToInvitees(user!)
                            try? viewContext.save()
                        }

                        isAnimation.toggle()
                    })
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
                    AnimalView(user: user ?? User())
                        .environment(\.managedObjectContext, viewContext)
                        .presentationDetents([.fraction(0.4)])
                        .presentationDragIndicator(.visible)
                }
                Spacer()
                NavigationLink {
                    AlarmListView(user: user)
                        .environment(\.managedObjectContext, viewContext)
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
    
    private func configureAllSetting() {
        if userId != "" {
            viewContext.performAndWait {
                let request = User.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", userId)
                user = try! viewContext.fetch(request).first
                healthData.healthAuth()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if !(user!.isFault) {
                    
                    let now = Date()
                    let nowComponent = Calendar.current.dateComponents([.year, .month, .day], from: now)
                    if let todayCoreDataHealth = user?.healths?.first(where: { Calendar.current.dateComponents([.year, .month, .day], from:($0 as! Health).date!) == nowComponent }) as? Health {
                        todayCoreDataHealth.exerciseTime = Int16(healthData.exerciseTime)
                        todayCoreDataHealth.burnedCalories = Int16(healthData.burnedCalories)
                        todayCoreDataHealth.numberOfSteps = Int16(healthData.numberOfSteps)
                    } else {
                        let newCoreDataHealth = Health(context: viewContext)
                        newCoreDataHealth.id = UUID()
                        newCoreDataHealth.burnedCalories = Int16(healthData.burnedCalories)
                        newCoreDataHealth.exerciseTime = Int16(healthData.exerciseTime)
                        newCoreDataHealth.numberOfSteps = Int16(healthData.numberOfSteps)
                        newCoreDataHealth.date = Date()
                        newCoreDataHealth.user = user
                        user?.addToHealths(newCoreDataHealth)
                    }
                    try? viewContext.save()
                }
            }
        }
    }
    private func reloadData() {
        defaultMission.calculatedBigProgress = CGFloat((healthData.numberOfSteps ) > defaultMission.defaultWalk ? Int(Int16(defaultMission.defaultWalk)) : (healthData.numberOfSteps )) / CGFloat(defaultMission.defaultWalk)
        defaultMission.calculatedMediumProgress  = CGFloat((healthData.burnedCalories ) > defaultMission.defaultCalories ? Int(Int16(defaultMission.defaultCalories)) : (healthData.burnedCalories )) / CGFloat(defaultMission.defaultCalories)
        defaultMission.calculatedSmallProgress  = CGFloat((healthData.exerciseTime ) > defaultMission.defaultExerciseTime ? Int(Int16(defaultMission.defaultExerciseTime)) : (healthData.exerciseTime )) / CGFloat(defaultMission.defaultExerciseTime)
    }
    private func resetForAnimation() {
        defaultMission.calculatedBigProgress = 0
        defaultMission.calculatedMediumProgress = 0
        defaultMission.calculatedSmallProgress = 0
    }
    
}
