//
//  IntExtension.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 11/11/22.
//

import Foundation

extension Int {
    
    var toString: String {
        return String(describing: self)
    }
    
    var toFloat: Float {
        return Float(self)
    }
    
    var toCalculatedString: String {
        let divisor = pow(10.0, Double(2))
        return String(((Double(self) / 100) * divisor).rounded() / divisor)
    }
    
    var toVolumeCalculatedString: String {
        let divisor = pow(10.0, Double(2))
        return String(((Double(self) / 1000) * divisor).rounded() / divisor)
    }
    
}
