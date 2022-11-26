//
//  HeightWeightType.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 22/11/22.
//

import UIKit

enum HeightWeightType {
    case height(unit: HeightUnit)
    case weight(unit: WeightUnit)

    var title: String? {
        switch self {
        case .height:
            return "Height"
        case .weight:
            return "Weight"
        }
    }
    
    var unitLabels: (String, String) {
        switch self {
        case .height:
            return ("CM", "Feet")
        case .weight:
            return ("Pound", "Kg")
        }
    }
    
    var unitLimit: (Int, Int) {
        switch self {
        case .height:
            return (300, 120)
        case .weight:
            return (220, 480)
        }
    }
}
