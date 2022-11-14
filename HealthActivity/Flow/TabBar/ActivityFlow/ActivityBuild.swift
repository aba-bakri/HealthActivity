//
//  ActivityBuild.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 10/11/22.
//

import Foundation
import UIKit

class ActivityBuild {
    
    static func build() -> UIViewController  {
        let activityVC = ActivityViewController()
        activityVC.router = ActivityRouter(viewController: activityVC)
        activityVC.viewModel = ActivityViewModel()
        return activityVC
    }
}
