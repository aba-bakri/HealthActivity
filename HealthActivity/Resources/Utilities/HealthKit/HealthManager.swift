//
//  HealthTest.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 10/11/22.
//

import Foundation
import HealthKit
import RxSwift

enum Result<T> {
    case success(T)
    case failure(error: String?)
}

enum EmptyResult {
    case success
    case failure(error: String?)
}

struct StatusProgressModel {
    var value: Double
    var day: Date
}

class HealthManager {
    
    static let shared = HealthManager()
    
    private let healthStore = HKHealthStore()
    private let disposeBag = DisposeBag()
    
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
    
    //MARK: Steps
    
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
    
    func getSteps(date: Date = Date()) -> Observable<Int> {
        return .create { [weak self] (observer) -> Disposable in
            let stepsCount = HKQuantityType.quantityType(forIdentifier: .stepCount)!
            var startDate = date
            var length = TimeInterval()
            _ = Calendar.current.dateInterval(of: .day, start: &startDate, interval: &length, for: startDate)
            let endDate: Date = startDate.addingTimeInterval(length)
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let query = HKStatisticsQuery(quantityType: stepsCount, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, results, error in
                if let error = error {
                    observer.onError(error)
                }
                if let results = results {
                    var resultCount = 0.0
                    if let sum = results.sumQuantity() {
                        resultCount = sum.doubleValue(for: HKUnit.count())
                    }
                    observer.onNext(resultCount.toInt)
                }
                observer.onCompleted()
            }
            self?.healthStore.execute(query)
            return Disposables.create()
        }
    }
    
    func getAge() -> Observable<String> {
        return .create { [weak self] (observer) -> Disposable in
            do {
                let birthDay = try self?.healthStore.dateOfBirthComponents()
                let calendar = Calendar.current
                let currentYear = calendar.component(.year, from: Date())
                if let birthDay = birthDay {
                    let birth = "\(currentYear - (birthDay.year ?? .zero))"
                    observer.onNext(birth)
                }
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    //MARK: Calories
    
    func getCalories(date: Date = Date()) -> Observable<Int> {
        return .create { [weak self] (observer) -> Disposable in
            let stepsCount = HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!
            var startDate = date
            var length = TimeInterval()
            _ = Calendar.current.dateInterval(of: .day, start: &startDate, interval: &length, for: startDate)
            let endDate: Date = startDate.addingTimeInterval(length)
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let query = HKStatisticsQuery(quantityType: stepsCount, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, results, error in
                if let error = error {
                    observer.onError(error)
                }
                if let results = results {
                    var resultCount = 0.0
                    if let sum = results.sumQuantity() {
                        resultCount = sum.doubleValue(for: HKUnit.kilocalorie())
                    }
                    observer.onNext(resultCount.toInt)
                }
                observer.onCompleted()
            }
            self?.healthStore.execute(query)
            return Disposables.create()
        }
    }
    
    //MARK: Get Active Points for ActivityScreen
    
    func getActivePoints(date: Date = Date()) -> Observable<Int> {
        return .create { [weak self] (observer) -> Disposable in
            let activePoints = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
            var startDate = date
            var length = TimeInterval()
            _ = Calendar.current.dateInterval(of: .day, start: &startDate, interval: &length, for: startDate)
            let endDate: Date = startDate.addingTimeInterval(length)
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let query = HKStatisticsQuery(quantityType: activePoints, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, results, error in
                if let error = error {
                    observer.onError(error)
                }
                if let results = results {
                    var resultCount = 0.0
                    if let sum = results.sumQuantity() {
                        resultCount = sum.doubleValue(for: HKUnit.kilocalorie())
                    }
                    observer.onNext(resultCount.toInt)
                }
                observer.onCompleted()
            }
            self?.healthStore.execute(query)
            return Disposables.create()
        }
    }
    
    //MARK: Distance
    
    func getDistance(date: Date = Date()) -> Observable<Double> {
        return .create { [weak self] (observer) -> Disposable in
            let distance = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
            var startDate = date
            var length = TimeInterval()
            _ = Calendar.current.dateInterval(of: .day, start: &startDate, interval: &length, for: startDate)
            let endDate: Date = startDate.addingTimeInterval(length)
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let query = HKStatisticsQuery(quantityType: distance, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, results, error in
                if let error = error {
                    observer.onError(error)
                }
                if let results = results {
                    var resultCount = 0.0
                    if let sum = results.sumQuantity() {
                        resultCount = sum.doubleValue(for: HKUnit.mile())
                    }
                    observer.onNext(resultCount * 1.60932)
                }
                observer.onCompleted()
            }
            self?.healthStore.execute(query)
            return Disposables.create()
        }
    }
    
    func getHeartRate(date: Date = Date()) -> Observable<StatusProgressModel> {
        return .create { [weak self] (observer) -> Disposable in
            let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
            var startDate = date
            var length = TimeInterval()
            _ = Calendar.current.dateInterval(of: .day, start: &startDate, interval: &length, for: startDate)
            let endDate: Date = startDate.addingTimeInterval(length)
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
            let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 1, sortDescriptors: sortDescriptors, resultsHandler: { (query, results, error) in
                if let error = error {
                    observer.onError(error)
                }
                if let results = results {
                    for result in results {
                        if let data = result as? HKQuantitySample {
                            let value = data.quantity.doubleValue(for: HKUnit(from: "count/min"))
                            observer.onNext(StatusProgressModel(value: value, day: date))
                        }
                    }
                }
                observer.onCompleted()
            })
            self?.healthStore.execute(query)
            return Disposables.create()
        }
    }
    
//    func test(date: [Date]) -> Observable<[StatusProgressModel]> {
//        return .create { [weak self] (observer) -> Disposable in
//            var heartRates = [StatusProgressModel]()
//            date.forEach { date in
//                let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
//                var startDate = date
//                var length = TimeInterval()
//                _ = Calendar.current.dateInterval(of: .day, start: &startDate, interval: &length, for: startDate)
//                let endDate: Date = startDate.addingTimeInterval(length)
//                let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
//                let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
//                let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 1, sortDescriptors: sortDescriptors, resultsHandler: { (query, results, error) in
//                    if let error = error {
//                        observer.onError(error)
//                    }
//                    if let results = results {
//                        var value: Double = .zero
//                        if !results.isEmpty {
//                            if let result = results.first as? HKQuantitySample {
//                                value = result.quantity.doubleValue(for: HKUnit(from: "count/min"))
//                            }
//                        }
//                        let heartRateModel = StatusProgressModel(value: value, day: date)
//                        heartRates.append(heartRateModel)
//                    }
//                })
//                self?.healthStore.execute(query)
//            }
//            observer.onNext(heartRates)
//            return Disposables.create()
//        }
//    }
    
//    func getHeartRate(forSpecificDate: Date = Date(), completion: @escaping((Result<StatusProgressModel>) -> Void)) {
//        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
//        let (start, end) = getWholeDate(date: forSpecificDate)
//        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
//        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
//        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 1, sortDescriptors: sortDescriptors, resultsHandler: { (query, results, error) in
//            self.heartRateInfo(date: forSpecificDate, results: results, completion: completion)
//        })
//        healthStore.execute(query)
//    }
//
//    private func heartRateInfo(date: Date, results: [HKSample]?, completion: @escaping((Result<StatusProgressModel>) -> Void)) {
//        if (results?.isEmpty ?? true) {
//            completion(.failure(error: "Haven't measured today"))
//        } else {
//            for (_, sample) in results!.enumerated() {
//                if let currData: HKQuantitySample = sample as? HKQuantitySample {
//                    let value = currData.quantity.doubleValue(for: HKUnit(from: "count/min"))
//                    if (results?.isEmpty ?? true) {
//                        completion(.success(StatusProgressModel(value: .zero, day: date)))
//                    } else {
//                        completion(.success(StatusProgressModel(value: value, day: date)))
//                    }
//                }
//            }
//        }
//    }
    
    //MARK: Height
    
    func getHeight(unit: HKUnit, completion: @escaping(Double) -> Void) {
        guard let heightType = HKQuantityType.quantityType(forIdentifier: .height) else {
            fatalError("Height cannot be changed")
        }
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        let query = HKSampleQuery(sampleType: heightType, predicate: nil, limit: 1, sortDescriptors: sortDescriptors) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample {
                let height = result.quantity.doubleValue(for: unit)
                completion(height)
            } else {
                completion(.zero)
            }
        }
        healthStore.execute(query)
    }
    
    func getHeight(unit: HKUnit) -> Observable<Double> {
        return .create { [weak self] (observer) -> Disposable in
            let heightType = HKQuantityType.quantityType(forIdentifier: .height)!
            let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
            let query = HKSampleQuery(sampleType: heightType, predicate: nil, limit: 1, sortDescriptors: sortDescriptors) { (query, results, error) in
                if let error = error {
                    observer.onError(error)
                }
                if let results = results {
                    var height: Double = .zero
                    if let result = results.first as? HKQuantitySample {
                        height = result.quantity.doubleValue(for: unit)
                    }
                    observer.onNext(height)
                }
                observer.onCompleted()
            }
            self?.healthStore.execute(query)
            return Disposables.create()
        }
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
    
    func getWeight(unit: HKUnit, completion: @escaping(Double) -> Void) {
        guard let bodyMassType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else {
            fatalError("Weight cannot be changed")
        }
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        let query = HKSampleQuery(sampleType: bodyMassType, predicate: nil, limit: 1, sortDescriptors: sortDescriptors) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample {
                let bodyMass = result.quantity.doubleValue(for: unit)
                completion(bodyMass)
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
        
//        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
//        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d", hours, minutes)
        
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
                if (results?.isEmpty ?? true) {
                    completion(StatusProgressModel(value: .zero, day: date))
                } else {
                    completion(StatusProgressModel(value: value, day: date))
                }
            }
        }
    }
    
    func getHeartRate(forSpecificDate: Date = Date(), completion: @escaping((Result<StatusProgressModel>) -> Void)) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        let (start, end) = getWholeDate(date: forSpecificDate)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 1, sortDescriptors: sortDescriptors, resultsHandler: { (query, results, error) in
            self.heartRateInfo(date: forSpecificDate, results: results, completion: completion)
        })
        healthStore.execute(query)
    }
    
    private func heartRateInfo(date: Date, results: [HKSample]?, completion: @escaping((Result<StatusProgressModel>) -> Void)) {
        if (results?.isEmpty ?? true) {
            completion(.failure(error: "Haven't measured today"))
        } else {
            for (_, sample) in results!.enumerated() {
                if let currData: HKQuantitySample = sample as? HKQuantitySample {
                    let value = currData.quantity.doubleValue(for: HKUnit(from: "count/min"))
                    if (results?.isEmpty ?? true) {
                        completion(.success(StatusProgressModel(value: .zero, day: date)))
                    } else {
                        completion(.success(StatusProgressModel(value: value, day: date)))
                    }
                }
            }
        }
    }
}

//MARK: Get sleep hours
extension HealthManager {
    func getSleepHours(forSpecificDate: Date = Date(), completion: @escaping(Double) -> Void) {
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            let (start, end) = getWholeDate(date: forSpecificDate)
            let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 30, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
                if let result = tmpResult {
                    let hours = result.map { item -> Double in
                        if let sample = item as? HKCategorySample {
                            if sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue {
                                let sleepTimeForOneDay = sample.endDate.timeIntervalSince(sample.startDate)
                                return sleepTimeForOneDay
                            } else {
                                return .zero
                            }
                        } else {
                            return .zero
                        }
                    }
                    let dayHours = hours.reduce(0, +)
                    hours.forEach { hours in
//                        debugPrint("Debug__\(hours)")
                    }
                    completion(dayHours)
                } else {
                    completion(.zero)
                }
            }
            healthStore.execute(query)
        }
    }
    
    func weeklySleepHours(forSpecificDate: Date = Date(), completion: @escaping(StatusProgressModel) -> Void) {
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            let (start, end) = getWholeDate(date: forSpecificDate)
            let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 30, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
                if let result = tmpResult {
                    let hours = result.map { item -> Double in
                        if let sample = item as? HKCategorySample {
                            if sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue {
                                let sleepTimeForOneDay = sample.endDate.timeIntervalSince(sample.startDate)
                                return sleepTimeForOneDay
                            } else {
                                return .zero
                            }
                        } else {
                            return .zero
                        }
                    }
                    let dayHours = hours.reduce(0, +)
                    completion(StatusProgressModel(value: dayHours, day: forSpecificDate))
                } else {
                    completion(StatusProgressModel(value: .zero, day: forSpecificDate))
                }
            }
            healthStore.execute(query)
        }
    }
}

extension TimeInterval {
    var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }

    var seconds: Int {
        return Int(self) % 60
    }

    var minutes: Int {
        return (Int(self) / 60 ) % 60
    }

    public var hours: Double {
        return Double(self) / 3600
    }

    var stringTime: String {
        if hours != 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else if minutes != 0 {
            return "\(minutes)m \(seconds)s"
        } else if milliseconds != 0 {
            return "\(seconds)s \(milliseconds)ms"
        } else {
            return "\(seconds)s"
        }
    }
}
