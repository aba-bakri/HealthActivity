//
//  HealthKitHelper.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import Foundation
import HealthKit

class HealthKitHelper: NSObject {
    
    static let shared = HealthKitHelper()
    let healthKitStore: HKHealthStore = HKHealthStore()
    
}

extension HealthKitHelper {
    
    func authorizeHealthKit(success: (() -> ())? = nil, failure: ((HealthKitError) -> ())? = nil) {
        
        // If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable() {
            failure?(HealthKitError.custom(title: "HealthKit is not available in this Device"))
            return
        }
        
        guard let stepsCount = HKObjectType.quantityType(forIdentifier: .stepCount),
              let pulse = HKObjectType.quantityType(forIdentifier: .heartRate),
              let bloodPressureSystolic = HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic),
              let bloodPressureDiastolic = HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic),
              let sleep = HKObjectType.categoryType(forIdentifier: .sleepAnalysis),
              let weigth = HKObjectType.quantityType(forIdentifier: .bodyMass) else {
            return
        }
        
        let healthKitTypesToRead: Set<HKObjectType> = [stepsCount, pulse, bloodPressureSystolic, bloodPressureDiastolic, sleep, weigth]
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
    
}
