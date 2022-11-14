//
//  StatusBuild.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 10/11/22.
//

import UIKit

class StatusBuild {
    
    static func build() -> UIViewController {
        let statusVC = StatusViewController()
        statusVC.router = StatusRouter(viewController: statusVC)
        return statusVC
    }
}
