//
//  HealthTest.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 10/11/22.
//

import Foundation
import HealthKit

enum EmptyResult {
    case success
    case failure(error: String?)
}

class HealthTest {
    
    static let shared = HealthTest()
    
    private let healthStore = HKHealthStore()
    
    func authorizeHealthKit(success: (() -> ())? = nil, failure: ((HealthKitError) -> ())? = nil) {
        
        let healthKitTypesToWrite : Set<HKSampleType> = [
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        ]
        
        let healthKitTypesToRead : Set<HKObjectType> = [
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
            HKQuantityType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.basalEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
            HKQuantityType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
            HKQuantityType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!
        ]
        
        // If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable() {
            failure?(HealthKitError.custom(title: "HealthKit is not available in this Device"))
            return
        }
        
        // Request HealthKit authorization
        healthStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (successFlag, error) in
            if let error = error {
                failure?(HealthKitError.defaultError(error: error as NSError))
            } else if successFlag {
                success?()
            } else {
                failure?(HealthKitError.unknownError)
            }
        }
    }
    
    func getSteps(forSpecificDate: Date = Date(), completion: @escaping(Int) -> Void) {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            fatalError("Step Count Type is no longer available in HealthKit")
        }
        let (start, end) = getWholeDate(date: forSpecificDate)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(.zero)
                return
            }
            let steps = sum.doubleValue(for: HKUnit.count())
            completion(steps.toInt)
        }
        
        healthStore.execute(query)
    }
    
    func getDistance(forSpecificDate: Date = Date(), completion: @escaping(Double) -> Void) {
        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            fatalError("Step Count Type is no longer available in HealthKit")
        }
        let (start, end) = getWholeDate(date: forSpecificDate)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(.zero)
                return
            }
            let distance = sum.doubleValue(for: HKUnit.mile())
            completion((distance * 1.60932))
        }
        
        healthStore.execute(query)
    }
    
    func getCalories(forSpecificDate: Date = Date(), completion: @escaping(Int) -> Void) {
        guard let caloriesType = HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned) else {
            fatalError("Step Count Type is no longer available in HealthKit")
        }
        let (start, end) = getWholeDate(date: forSpecificDate)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: caloriesType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(.zero)
                return
            }
            let calories = sum.doubleValue(for: HKUnit.kilocalorie())
            completion(calories.toInt)
        }
        
        healthStore.execute(query)
    }
    
    func getActivePoints(forSpecificDate: Date = Date(), completion: @escaping(Int) -> Void) {
        guard let activePointsType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            fatalError("Step Count Type is no longer available in HealthKit")
        }
        let (start, end) = getWholeDate(date: forSpecificDate)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: activePointsType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(.zero)
                return
            }
            let calories = sum.doubleValue(for: HKUnit.kilocalorie())
            completion(calories.toInt)
        }
        
        healthStore.execute(query)
    }
    
    func getHeight(completion: @escaping(Int) -> Void) {
        guard let heightType = HKQuantityType.quantityType(forIdentifier: .height) else {
            fatalError("Height cannot be changed")
        }
        let query = HKSampleQuery(sampleType: heightType, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample {
                let heightInch = result.quantity.doubleValue(for: HKUnit.inch())
                completion(heightInch.toInt)
                return
            } else {
                completion(.zero)
            }
        }
        healthStore.execute(query)
    }
    
    func getWeight(completion: @escaping(Int) -> Void) {
        guard let bodyMassType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else {
            fatalError("Height cannot be changed")
        }
        let query = HKSampleQuery(sampleType: bodyMassType, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample {
                let bodyMassKg = result.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                completion(bodyMassKg.toInt)
                return
            } else {
                completion(.zero)
            }
        }
        healthStore.execute(query)
    }
    
    func changeWeight(weight: Double, date: Date, completion: @escaping (EmptyResult) -> Void) {
        guard let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else {
            fatalError("Weight cannot be changed")
        }
        
        let weightUnit: HKUnit = HKUnit.inch()
        let weightQuantity = HKQuantity(unit: weightUnit, doubleValue: weight)
        let weightSample = HKQuantitySample(type: weightType, quantity: weightQuantity, start: date, end: date)
        healthStore.save(weightSample) { success, error in
            if let error = error {
                completion(.failure(error: error.localizedDescription))
            } else {
                completion(.success)
            }
        }
    }
    
    func changeHeight(height: Int, date: Date, completion: @escaping (EmptyResult) -> Void) {
        guard let heightType = HKQuantityType.quantityType(forIdentifier: .height) else {
            fatalError("Height cannot be changed")
        }
        
        let heightUnit: HKUnit = HKUnit.inch()
        let heightQuantity = HKQuantity(unit: heightUnit, doubleValue: Double(height))
        let heightSample = HKQuantitySample(type: heightType, quantity: heightQuantity, start: date, end: date)
        healthStore.save(heightSample) { success, error in
            if let error = error {
                completion(.failure(error: error.localizedDescription))
            } else {
                completion(.success)
            }
        }
    }
    
    func getWholeDate(date : Date) -> (startDate:Date, endDate: Date) {
        var startDate = date
        var length = TimeInterval()
        _ = Calendar.current.dateInterval(of: .day, start: &startDate, interval: &length, for: startDate)
        let endDate:Date = startDate.addingTimeInterval(length)
        return (startDate,endDate)
    }
    
    func getSex() -> String {
        do {
            let getSex = try healthStore.biologicalSex()
            return getReadableBiologicalSex(sex: getSex.biologicalSex)
        } catch let error {
            return error.localizedDescription
        }
    }
    
    func getAge() -> String {
        do {
            let birthDay = try healthStore.dateOfBirthComponents()
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date() )
            return "\(currentYear - (birthDay.year ?? .zero))"
        } catch {
            return error.localizedDescription
        }
    }
    
    func getReadableBiologicalSex(sex: HKBiologicalSex?) -> String {
        var biologicalSex: String = "Not Set"
        
        if sex != nil {
            switch sex!.rawValue {
            case 0:
                biologicalSex = ""
            case 1:
                biologicalSex = "Female"
            case 2:
                biologicalSex = "Male"
            case 3:
                biologicalSex = "Other"
            default:
                biologicalSex = "Not Set"
            }
        }
        return biologicalSex
    }
}
