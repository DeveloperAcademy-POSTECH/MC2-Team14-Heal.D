//
//  HealthDataView.swift
//  MC2
//
//  Created by 송재훈 on 2023/05/07.
//

import SwiftUI
import HealthKit

struct HealthDataView: View {
    @State var healthStore: HKHealthStore?
    
    @State var todayStepCount = 0.0
    @State var todayActiveEnergy = 0.0
    @State var todayExerciseTime = 0.0

    func HealthAuth() {
        guard HKHealthStore.isHealthDataAvailable() else { fatalError("This app requires a device that supports HealthKit") }
        
        self.healthStore = HKHealthStore()
        
        let share = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!, HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!])

        let read = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!, HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!, HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!])
        
        self.healthStore!.requestAuthorization(toShare: share, read: read) { (success, error) in
            print("Request Authorization -- Success: ", success, " Error: ", error ?? "nil")
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
        VStack {
            Spacer()
            Text("stepCount is \(todayStepCount)")
            Text("activeEnergy is \(todayActiveEnergy)")
            Text("exerciseTime is \(todayExerciseTime)")
            
            Spacer()
            Button("HealthAuth") {
                HealthAuth()
            }
            Button("StepCount") {
                StepCount()
            }
            Button("ActiveEnergy") {
                ActiveEnergy()
            }
            Button("ExerciseTime") {
                ExerciseTime()
            }
            
            Spacer()
        }
        .padding()
    }
}

struct HealthDataView_Previews: PreviewProvider {
    static var previews: some View {
        HealthDataView()
    }
}
