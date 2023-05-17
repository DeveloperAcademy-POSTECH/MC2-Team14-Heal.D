//
//  HealthData.swift
//  trees
//
//  Created by 조기연 on 2023/05/16.
//

import Foundation
import HealthKit


class HealthData: ObservableObject {
    var healthStore: HKHealthStore? = nil
    @Published var isChanged: Bool = false
    @Published var numberOfSteps = 0
    @Published var burnedCalories = 0
    @Published var exerciseTime = 0
    
    
    func healthAuth() {
        guard HKHealthStore.isHealthDataAvailable() else { fatalError("This app requires a device that supports HealthKit") }
        
        self.healthStore = HKHealthStore()
        
        let share = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!, HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!])
        
        let read = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
        ])
        
        self.healthStore!.requestAuthorization(toShare: share, read: read) { (success, error) in
            if let error = error {
                print("Error ::: \(error)")
                return
            }
            
            
            self.StepCount()
            self.ActiveEnergy()
            self.ExerciseTime()
            
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
        var numberOfSteps = Double()
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: today, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortByDate]) {
            query, results, error in
            
            guard let samples = results as? [HKQuantitySample] else {
                // Handle any errors here.
                return
            }
            
            for sample in samples {
                numberOfSteps += sample.quantity.doubleValue(for: .count())
            }
            
            // The results come back on an anonymous background queue.
            // Dispatch to the main queue before modifying the UI.
            
            DispatchQueue.main.async {
                self.numberOfSteps = Int(numberOfSteps)
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
        var burnedCalories = Double()
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: today, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortByDate]) {
            query, results, error in
            
            guard let samples = results as? [HKQuantitySample] else {
                // Handle any errors here.
                return
            }
            
            for sample in samples {
                burnedCalories += sample.quantity.doubleValue(for: .kilocalorie())
            }
            
            // The results come back on an anonymous background queue.
            // Dispatch to the main queue before modifying the UI.
            
            DispatchQueue.main.async {
                self.burnedCalories = Int(burnedCalories)
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
        var exerciseTime = Double()
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: today, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortByDate]) {
            query, results, error in
            
            guard let samples = results as? [HKQuantitySample] else {
                // Handle any errors here.
                return
            }
            
            for sample in samples {
                exerciseTime += sample.quantity.doubleValue(for: .minute())
            }
            
            // The results come back on an anonymous background queue.
            // Dispatch to the main queue before modifying the UI.
            
            DispatchQueue.main.async {
                self.exerciseTime = Int(exerciseTime)
            }
        }
        
        healthStore?.execute(query)
    }
}
