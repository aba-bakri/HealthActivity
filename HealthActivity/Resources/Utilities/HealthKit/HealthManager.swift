//
//  HealthTest.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 10/11/22.
//

import Foundation
import HealthKit

enum Result<T> {
    case success(T)
    case failure(error: String?)
}

enum EmptyResult {
    case success
    case failure(error: String?)
}

struct StatusProgressModel {
    var heartBPM: Int
    var day: String
}

class HealthManager {
    
    static let shared = HealthManager()
    
    private let healthStore = HKHealthStore()
    
    func authorizeHealthKit(success: (() -> ())? = nil, failure: ((HealthKitError) -> ())? = nil) {
        
        let healthKitTypesToWrite : Set<HKSampleType> = [
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        ]
        
        let healthKitTypesToRead : Set<HKObjectType> = [
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
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
    
    //MARK: Height
    
    func getHeight(unit: HKUnit, completion: @escaping(Double) -> Void) {
        guard let heightType = HKQuantityType.quantityType(forIdentifier: .height) else {
            fatalError("Height cannot be changed")
        }
        let (start, end) = getWholeDate(date: Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let query = HKSampleQuery(sampleType: heightType, predicate: predicate, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample {
                let height = result.quantity.doubleValue(for: unit)
                completion(height)
            } else {
                completion(.zero)
            }
        }
        healthStore.execute(query)
    }
    
    func changeHeight(unit: HKUnit, height: Double, completion: @escaping(EmptyResult) -> Void) {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .height) else {
            fatalError("Height cannot be changed")
        }
        let bodyMass = HKQuantitySample(type: quantityType,
                                        quantity: HKQuantity.init(unit: unit, doubleValue: height),
                                        start: Date(),
                                        end: Date())
        healthStore.save(bodyMass) { success, error in
            if let error = error {
                completion(.failure(error: error.localizedDescription))
            } else {
                completion(.success)
            }
        }
    }
    
    //MARK: Weight
    
    func getWeight(unit: HKUnit, completion: @escaping(Int) -> Void) {
        guard let bodyMassType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else {
            fatalError("Weight cannot be changed")
        }
        let (start, end) = getWholeDate(date: Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let query = HKSampleQuery(sampleType: bodyMassType, predicate: predicate, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample {
                let bodyMass = result.quantity.doubleValue(for: unit)
                completion(bodyMass.toInt)
                return
            } else {
                completion(.zero)
            }
        }
        healthStore.execute(query)
    }
    
    func changeWeight(unit: HKUnit, weight: Double, completion: @escaping(EmptyResult) -> Void) {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass) else {
            fatalError("Weight cannot be changed")
        }
        let bodyMass = HKQuantitySample(type: quantityType,
                                        quantity: HKQuantity.init(unit: unit, doubleValue: weight),
                                        start: Date(),
                                        end: Date())
        healthStore.save(bodyMass) { success, error in
            if let error = error {
                completion(.failure(error: error.localizedDescription))
            } else {
                completion(.success)
            }
        }
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

extension TimeInterval{
    func stringFromTimeInterval() -> String {
        
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
        
    }
}

extension HealthManager {
    func getWholeDate(date : Date) -> (startDate:Date, endDate: Date) {
        var startDate = date
        var length = TimeInterval()
        _ = Calendar.current.dateInterval(of: .day, start: &startDate, interval: &length, for: startDate)
        let endDate:Date = startDate.addingTimeInterval(length)
        return (startDate,endDate)
    }
}

extension HealthManager {
    func getHeartRate(forSpecificDate: Date = Date(), completion: @escaping(StatusProgressModel) -> Void) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            fatalError("Step Count Type is no longer available in HealthKit")
        }
        //predicate
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: forSpecificDate as Date)
        
        guard let startDate: Date = calendar.date(from: components) as Date? else {
            completion(StatusProgressModel(heartBPM: 0, day: "None"))
            return
        }
        var dayComponent = DateComponents()
        dayComponent.day = 1
        //        let (start, end) = getWholeDate(date: forSpecificDate)
        //        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let endDate: Date? = calendar.date(byAdding: dayComponent, to: startDate as Date) as Date?
        let predicate = HKQuery.predicateForSamples(withStart: startDate as Date, end: endDate as Date?, options: [])
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 1, sortDescriptors: sortDescriptors, resultsHandler: { (query, results, error) in
            guard error == nil else {
                completion(StatusProgressModel(heartBPM: 0, day: "None"))
                return
            }
            self.heartRateInfo(date: forSpecificDate, results: results, completion: completion)
        })
        healthStore.execute(query)
    }
    
    private func heartRateInfo(date: Date, results: [HKSample]?, completion: @escaping(StatusProgressModel) -> Void) {
        for (_, sample) in results!.enumerated() {
            guard let currData:HKQuantitySample = sample as? HKQuantitySample else { return }
            let value = currData.quantity.doubleValue(for: HKUnit(from: "count/min"))
            if (results?.isEmpty ?? true) {
                completion(StatusProgressModel(heartBPM: value.toInt, day: date.ddd))
            } else {
                let model = StatusProgressModel(heartBPM: value.toInt, day: date.ddd)
                completion(model)
            }
        }
    }
    
    func getWeeklyHeartRate(forSpecificDate: Date = Date(), completion: @escaping((StatusProgressModel) -> Void)) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        let (start, end) = getWholeDate(date: forSpecificDate)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 1, sortDescriptors: sortDescriptors, resultsHandler: { (query, results, error) in
            self.weekHeartRate(date: forSpecificDate, results: results, completion: completion)
        })
        healthStore.execute(query)
    }
    
    private func weekHeartRate(date: Date, results: [HKSample]?, completion: @escaping((StatusProgressModel) -> Void)) {
        for (_, sample) in results!.enumerated() {
            if let currData: HKQuantitySample = sample as? HKQuantitySample {
                let value = currData.quantity.doubleValue(for: HKUnit(from: "count/min"))
                completion(StatusProgressModel(heartBPM: value.toInt, day: date.ddd))
            }
        }
    }
}

//MARK: Get sleep hours
extension HealthManager {
    func getSleepHours(forSpecificDate: Date = Date()) {
//        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
//            let (start, end) = getWholeDate(date: forSpecificDate)
//            let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
//            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
//            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 30, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
//                if let result = tmpResult {
//                    for item in result {
//                        if let sample = item as? HKCategorySample {
//                            let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
//                            print("sleep: \(sample.startDate) \(sample.endDate) - source: \(sample.source.name) - value: \(value)")
//                            //   let seconds = endDate.timeIntervalSinceDate(sample.startDate)
//                            let seconds = sample.startDate.timeIntervalSince(sample.endDate)
//                            let minutes = seconds/60
//                            let hours = minutes/60
//                            print(seconds)
//                            print(minutes)
//                            print(hours)
//                        }
//                    }
//                } else{
//                    print(error?.localizedDescription)
//                }
//            }
//            healthStore.execute(query)
//        }
    }
}
