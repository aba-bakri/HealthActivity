//
//  DoubleExtension.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 11/11/22.
//

import Foundation

extension Double {
    
    var toString: String {
        return String(describing: self)
    }
    
    var toInt: Int {
        return Int(self)
    }
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
