//
//  HealthStore.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 10/11/22.
//

import Foundation
import HealthKit

func getAnchor(identifier: String) -> HKQueryAnchor {
    let key = "HKClientAnchorKey_\(identifier)"
    
    if let encoded = UserDefaults.standard.data(forKey: key) {
        if let anchor = NSKeyedUnarchiver.unarchiveObject(with: encoded) as? HKQueryAnchor {
            print("Anchor is retrieved for: \(key)")
            return anchor
        }
    }
    
    print("Anchor is not retrieved for(It's nil): \(key)")
    return HKQueryAnchor(fromValue: Int(HKAnchoredObjectQueryNoAnchor))
}

func saveAnchorObject(anchor : HKQueryAnchor? = nil, identifier: String) {
    let key = "HKClientAnchorKey_\(identifier)"
    
    if let anchor = anchor {
        let encoded = NSKeyedArchiver.archivedData(withRootObject: anchor)
        
        UserDefaults.standard.setValue(encoded, forKey: key)
        UserDefaults.standard.synchronize()
        
        print("Anchor is saved for: \(key)")
    }
}

final class HealthManager {
    
    static let shared = HealthManager()
    
    private let healthKitStore: HKHealthStore = HKHealthStore()
    
    func authorizeHealthKit(success: (() -> ())? = nil, failure: ((HealthKitError) -> ())? = nil) {
        let healthKitTypesToRead : Set<HKSampleType> = [
            HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
            HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
            HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!,
            HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.basalEnergyBurned)!,
            HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
            HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
            HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        ]

        // If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable() {
            failure?(HealthKitError.custom(title: "HealthKit is not available in this Device"))
            return
        }

        // Request HealthKit authorization
        healthKitStore.requestAuthorization(toShare: nil, read: healthKitTypesToRead) { (successFlag, error) in
            if let error = error {
                failure?(HealthKitError.defaultError(error: error as NSError))
            } else if successFlag {
                success?()
            } else {
                failure?(HealthKitError.unknownError)
            }
        }
    }
    
//    func readHeight(completion: @escaping(String) -> Void) {
//        let heightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
//        let query = HKSampleQuery(sampleType: heightType, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
//            
//            if let result = results?.first as? HKQuantitySample {
//                print("Height => \(result.quantity)")
//                completion("\(result.quantity.doubleValue(for: HKUnit.inch()))")
//            } else{
//                print("OOPS didnt get height \nResults => \(results), error => \(error)")
//                completion(error?.localizedDescription ?? "")
//            }
//        }
//        self.healthKitStore.execute(query)
//    }
//    
//    func writeHeight(height: Double, completion: @escaping (Bool, Error?) -> Void) {
//        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height) {
//            let date = Date()
//            let quantity = HKQuantity(unit: HKUnit.inch(), doubleValue: height)
//            let sample = HKQuantitySample(type: type, quantity: quantity, start: date, end: date)
//            self.healthKitStore.save(sample, withCompletion: { (success, error) in
//                completion(success, error)
//            })
//        }
//    }
    
}

extension HealthManager {
    func startEnablingBackgroundDelivery() {
        guard let stepsCount = HKObjectType.quantityType(forIdentifier: .stepCount),
              let pulse = HKObjectType.quantityType(forIdentifier: .heartRate),
              let bloodPressureCorrelationType = HKObjectType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.bloodPressure),
              let sleep = HKObjectType.categoryType(forIdentifier: .sleepAnalysis),
              let weigth = HKObjectType.quantityType(forIdentifier: .bodyMass) else {
            return
        }
        
        let types = [stepsCount, pulse, bloodPressureCorrelationType, sleep, weigth]
        types.forEach { setUpBackgroundDeliveryFor(type: $0) }
    }
    
    func setUpBackgroundDeliveryFor(type: HKObjectType?) {
        guard let sampleType = type as? HKSampleType else { print("ERROR: \(type?.identifier ?? "") is not an HKSampleType"); return }
        
        func queryForUpdates(type: HKObjectType, success: (() -> ())? = nil, failure: ((HealthKitError) -> ())? = nil) {
            
            switch type {
            case HKObjectType.quantityType(forIdentifier: .stepCount):
                getStepsSessions(success: success, failure: failure)
                
            case HKObjectType.quantityType(forIdentifier: .heartRate):
                getPulseSessions(success: success, failure: failure)
                
            case HKObjectType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.bloodPressure):
                getBloodPressureSessions(succes: success, failure: failure)
                
            case HKObjectType.categoryType(forIdentifier: .sleepAnalysis):
                getSleepAnalysisSessions(success: success, failure: failure)
                
            case HKObjectType.quantityType(forIdentifier: .bodyMass):
                getWeightSessions(succes: success, failure: failure)
                
            default: debugPrint("Unhandled HKObjectType: \(type)")
            }
        }
        
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil) { (query: HKObserverQuery, completionHandler: @escaping HKObserverQueryCompletionHandler, error: Error?) in
            
            var logString = "observer query update handler called for type \(sampleType.identifier)"
            
            if let error = error {
                logString += ", with error: \(error)"
            }
            print(logString)
            
            queryForUpdates(type: sampleType, success: {
                //Tell Apple we are done handling this event.  This needs to be done inside this handler
                completionHandler()
            }, failure: { (error) in
                //Tell Apple we are done handling this event.  This needs to be done inside this handler
                completionHandler()
            })
            
        }
        
        enableBackgroundQuery(query, sampleType: sampleType, frequency: .immediate)
    }
    
    func enableBackgroundQuery(_ query: HKObserverQuery, sampleType: HKObjectType, frequency: HKUpdateFrequency) {
        healthKitStore.execute(query)
        
        healthKitStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate) { (succeeded: Bool, error: Error?) in
            if succeeded {
                print("Enabled background delivery of \(sampleType.identifier) changes")
            } else {
                if let theError = error {
                    print("Failed to enable background delivery of \(sampleType.identifier) changes. ")
                    print("Error = \(theError)")
                }
            }
        }
    }
    
    func disableBackgroundQuery() {
        // Disabling background queries
        healthKitStore.disableAllBackgroundDelivery { (succeeded: Bool, error: Error?) in
            if succeeded {
                print("Disabled all background delivery")
            } else {
                if let theError = error {
                    print("Failed to Disabled all background delivery")
                    print("Error = \(theError)")
                }
            }
        }
    }
}


extension HealthManager {
    
    func getSleepAnalysisSessions(success: (() -> ())? = nil, failure: ((HealthKitError) -> ())? = nil) {
        healthDataForQuantityType(HKObjectType.categoryType(forIdentifier: .sleepAnalysis), success: success, failure: failure)
    }
    
    func getStepsSessions(success: (() -> ())? = nil, failure: ((HealthKitError) -> ())? = nil) {
        healthDataForQuantityType(HKObjectType.quantityType(forIdentifier: .stepCount), success: success, failure: failure)
    }
    
    func getPulseSessions(success: (() -> ())? = nil, failure: ((HealthKitError) -> ())? = nil) {
        healthDataForQuantityType(HKObjectType.quantityType(forIdentifier: .heartRate), success: success, failure: failure)
    }
    
    func getWeightSessions(succes: (() -> ())? = nil, failure: ((HealthKitError) -> ())? = nil) {
        healthDataForQuantityType(HKObjectType.quantityType(forIdentifier: .bodyMass), success: succes, failure: failure)
    }
    
    func getBloodPressureSessions(succes: (() -> ())? = nil, failure: ((HealthKitError) -> ())? = nil) {
        healthDataForQuantityType(HKQuantityType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.bloodPressure), success: succes, failure: failure)
    }
    
    func healthDataForQuantityType(_ healthQuantityType: HKObjectType?, success: (() -> ())? = nil, failure: ((HealthKitError) -> ())? = nil )
    {
        guard let healthQuantityType = healthQuantityType as? HKSampleType else {
            failure?(HealthKitError.custom(title: "'healthQuantityType' is nil"))
            return
        }
        
        if (HKHealthStore.isHealthDataAvailable()) {
            let query = HKAnchoredObjectQuery(type: healthQuantityType, predicate: nil, anchor: getAnchor(identifier: healthQuantityType.identifier), limit: Int(HKObjectQueryNoLimit)) { (query, newSamples, deletedSamples, newAnchor, error) in
                
//                HealtKitDataServiceManager.shared.sendHealtDataToServer(newSamples: newSamples, newAnchor: newAnchor, newAnchor_Identifier: healthQuantityType.identifier, success: success, failure: failure)
            }
            
            self.healthKitStore.execute(query)
        } else {
            failure?(HealthKitError.custom(title: "'HKHealthStore.isHealthDataAvailable()' is false"))
        }
    }
    
}
