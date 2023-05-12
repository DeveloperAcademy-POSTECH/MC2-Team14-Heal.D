//
//  ContentView.swift
//  MC2
//
//  Created by 송재훈 on 2023/05/07.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @State var button = false
    @State var isAnimation = false
    
    @StateObject var viewModel = ContentViewModel()
    
    @State var healthStore: HKHealthStore?
    
    @State var todayStepCount = 0.0
    @State var todayActiveEnergy = 0.0
    @State var todayExerciseTime = 0.0
    
    @State var showSheet: Bool = false
    
    func HealthAuth() {
        guard HKHealthStore.isHealthDataAvailable() else { fatalError("This app requires a device that supports HealthKit") }
        
        self.healthStore = HKHealthStore()
        
        let share = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!, HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!])
        
        let read = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!, HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!, HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!])
        
        self.healthStore!.requestAuthorization(toShare: share, read: read) { (success, error) in
            print("Request Authorization -- Success: ", success, " Error: ", error ?? "nil")
            
            if success {
                StepCount()
                ActiveEnergy()
                ExerciseTime()
            }
        }
    }
    
    func StepCount() {
        guard HKHealthStore.isHealthDataAvailable() else { fatalError("This app requires a device that supports HealthKit") }
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .stepCount) else { return }
        
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        
        guard let startDate = calendar.date(from: components) else {
            fatalError("*** Unable to create the start date ***")
        }
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            fatalError("*** Unable to create the end date ***")
        }
        
        let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        let sortByDate = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        var stepCountSum = Double()
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: today, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortByDate]) {
            query, results, error in
            
            guard let samples = results as? [HKQuantitySample] else {
                // Handle any errors here.
                return
            }
            
            for sample in samples {
                stepCountSum += sample.quantity.doubleValue(for: .count())
            }
            
            // The results come back on an anonymous background queue.
            // Dispatch to the main queue before modifying the UI.
            
            DispatchQueue.main.async {
                todayStepCount = stepCountSum
            }
        }
        
        healthStore?.execute(query)
    }
    
    func ActiveEnergy() {
        guard HKHealthStore.isHealthDataAvailable() else { fatalError("This app requires a device that supports HealthKit") }
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        
        guard let startDate = calendar.date(from: components) else {
            fatalError("*** Unable to create the start date ***")
        }
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            fatalError("*** Unable to create the end date ***")
        }
        
        let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        let sortByDate = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        var activeEnergySum = Double()
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: today, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortByDate]) {
            query, results, error in
            
            guard let samples = results as? [HKQuantitySample] else {
                // Handle any errors here.
                return
            }
            
            for sample in samples {
                activeEnergySum += sample.quantity.doubleValue(for: .kilocalorie())
            }
            
            // The results come back on an anonymous background queue.
            // Dispatch to the main queue before modifying the UI.
            
            DispatchQueue.main.async {
                todayActiveEnergy = activeEnergySum
            }
        }
        
        healthStore?.execute(query)
    }
    
    func ExerciseTime() {
        guard HKHealthStore.isHealthDataAvailable() else { fatalError("This app requires a device that supports HealthKit") }
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .appleExerciseTime) else { return }
        
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        
        guard let startDate = calendar.date(from: components) else {
            fatalError("*** Unable to create the start date ***")
        }
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            fatalError("*** Unable to create the end date ***")
        }
        
        let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        let sortByDate = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        var exerciseTimeSum = Double()
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: today, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortByDate]) {
            query, results, error in
            
            guard let samples = results as? [HKQuantitySample] else {
                // Handle any errors here.
                return
            }
            
            for sample in samples {
                exerciseTimeSum += sample.quantity.doubleValue(for: .minute())
            }
            
            // The results come back on an anonymous background queue.
            // Dispatch to the main queue before modifying the UI.
            
            DispatchQueue.main.async {
                todayExerciseTime = exerciseTimeSum
            }
        }
        
        healthStore?.execute(query)
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                let geoWidth = geo.size.width
                let geoHeight = geo.size.height
                
                Image("Sky")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                HStack(spacing: 0){
                    Image("Cloud")
                        .resizable()
                        .frame(width: geoWidth * 1.2, height: geoHeight * 0.6)
                        .offset(x: isAnimation ? -geoWidth * 1.2 : geoWidth * 0)
                        .animation(.linear(duration: 10).repeatForever(autoreverses: false), value: isAnimation)
                    
                    Image("Cloud")
                        .resizable()
                        .frame(width: geoWidth * 1.2, height: geoHeight * 0.6)
                        .offset(x: isAnimation ? -geoWidth * 1.2 : geoWidth * 0)
                        .animation(.linear(duration: 10).repeatForever(autoreverses: false), value: isAnimation)
                }
                .onAppear {
                    isAnimation = true
                }
                
                Image("Land")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .ignoresSafeArea()
                
                
                SnapCarousel()
                    .environmentObject(viewModel.stateModel)
                    .frame(height: geoHeight * 0.3)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .ignoresSafeArea()
                    .onAppear {
                        HealthAuth()
                    }
                
                
                Button {
                    showSheet.toggle()
                } label: {
                    Rectangle()
                        .frame(width: 40, height: 40)
                }
                .sheet(isPresented: $showSheet) {
                    BedgeView()
                        .presentationDetents([.fraction(0.4)])
                        .presentationDragIndicator(.visible)
                }
                
                
                NavigationLink {
                    AlartListView()
                } label: {
                    Image("alarm")
                }
                .padding(.trailing, geoWidth * 0.05)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
