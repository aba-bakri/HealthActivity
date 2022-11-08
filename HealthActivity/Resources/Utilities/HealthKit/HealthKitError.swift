//
//  HealthKitError.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import Foundation

enum HealthKitError: Error {
    case custom(title: String)
    case defaultError(error: Error)
    case unknownError
}

extension HealthKitError {
    var errorDescription: String {
        switch self {
        case .custom(let title):
            return title
        case .defaultError(let error):
            return error.localizedDescription
        case .unknownError:
            return "An unknown error."
        }
    }
}
