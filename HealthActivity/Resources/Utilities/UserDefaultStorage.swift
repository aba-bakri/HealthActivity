//
//  UserDefaultStorage.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 17/11/22.
//

import Foundation
import HealthKit

enum HeightUnit: Codable {
    case cm
    case feet
    
    var measure: String {
        switch self {
        case .cm:
            return " Cm"
        case .feet:
            return " ”"
        }
    }
    
    var unit: HKUnit {
        switch self {
        case .cm:
            return .meter()
        case .feet:
            return .inch()
        }
    }
}

enum WeightUnit: Codable {
    case pound
    case kg
    
    var measure: String {
        switch self {
        case .pound:
            return " Lb"
        case .kg:
            return " Kg"
        }
    }
    
    var unit: HKUnit {
        switch self {
        case .pound:
            return .pound()
        case .kg:
            return .gramUnit(with: .kilo)
        }
    }
}

struct UserDefaultStorage {
    
    @Storage(key: "isOnboarded", defaultValue: false)
    static var isOnboarded: Bool
    
    @Storage(key: "userIdentifier", defaultValue: "")
    static var userIdentifier: String
    
    @Storage(key: "email", defaultValue: nil)
    static var email: String?
    
    @Storage(key: "firstName", defaultValue: "Guest")
    static var firstName: String?
    
    @Storage(key: "heightUnit", defaultValue: HeightUnit.cm)
    static var heightUnit: HeightUnit
    
    @Storage(key: "weightUnit", defaultValue: WeightUnit.pound)
    static var weightUnit: WeightUnit
}

@propertyWrapper
struct Storage<T: Codable> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }

            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)

            // Set value to UserDefaults
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

@propertyWrapper
struct EncryptedStringStorage {

    private let key: String

    init(key: String) {
        self.key = key
    }

    var wrappedValue: String {
        get {
            // Get encrypted string from UserDefaults
            return UserDefaults.standard.string(forKey: key) ?? ""
        }
        set {
            // Encrypt newValue before set to UserDefaults
            let encrypted = encrypt(value: newValue)
            UserDefaults.standard.set(encrypted, forKey: key)
        }
    }

    private func encrypt(value: String) -> String {
        // Encryption logic here
        return String(value.reversed())
    }
}
