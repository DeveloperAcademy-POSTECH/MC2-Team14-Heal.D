//
//  OnboardingView.swift
//  trees
//
//  Created by 조기연 on 2023/05/14.
//

import SwiftUI
import CloudKit
import CoreData

struct OnboardingView: View {
    enum OnboardingState {
        case start
        case apply
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    @State var userName: String = ""
    @State var onboardingState = OnboardingState.start
    @Binding var isFirst: Bool
    
    let userId: String
    
    var body: some View {
        ZStack {
            BackgroundView()
            Image("onboardingTitle")
                .offset(y: -200)
            upperSign
            lowerSign
        }
    }
    
    var upperSign: some View {
        ZStack {
            Image("onboardingStart")
                .offset(y: onboardingState == .start ? 250 : 100)
                .animation(.linear(duration: 0.5), value: onboardingState)
                .onTapGesture {
                    onboardingState = .apply
                }
            
            Image("onboardingSign")
                .overlay {
                    textField
                }
                .offset(y: onboardingState == .start ? 250 : 100)
                .animation(.linear(duration: 0.5), value: onboardingState)
                .opacity(onboardingState == .start ? 0.0 : 1.0)
        }
    }
    
    var lowerSign: some View {
        Image("onboardingApply")
            .offset(y: userName == "" ? 500 : 250)
            .animation(.linear(duration: 0.5), value: userName == "")
            .onTapGesture {
                initialize(name: userName)
                CloudKitNotification.shared.requestNotificationPermission()
                CloudKitNotification.shared.subcribeToNotifications()
                isFirst.toggle()
            }
    }
    
    var textField: some View {
        ZStack {
            Rectangle()
                .fill(.shadow(.inner(radius: 2, x: 1, y: 1)))
                .foregroundColor(Color("onboardingColor"))
                .frame(width: 250, height: 40)
            
                .overlay {
                    TextField(text: $userName) {
                        Text("이름을 입력해주세요!")
                            .foregroundColor(Color("onboardingPlaceholder"))
                            .font(.system(size: 24, weight: .heavy))
                    }
                    .foregroundColor(.clear)
                    .font(.system(size: 24, weight: .heavy))
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .padding(.leading, 10)
                    
                    Text(userName)
                        .foregroundStyle(
                            .shadow(.inner(radius: 0, x: 1, y: 1)))
                        .font(.system(size: 24, weight: .heavy))
                        .foregroundColor(Color("onboardingText"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                }
        }
    }
    
    private func initialize(name: String) {
        let user = User(context: viewContext)
        user.id = userId
        user.name = name
        user.code = String(UUID().uuidString.prefix(6))
        user.badges = []
        for name in BadgeModel.names {
            user.badges!.append(BadgeModel(name: name, isOn: false, isLock: false))
        }
        
        let grow = Grow(context: viewContext)
        grow.id = UUID()
        grow.day = 1
        grow.level = 1
        
        user.grow = grow
        user.familys = [user]
        
        grow.user = user
        
        try? viewContext.save()
    }
}
