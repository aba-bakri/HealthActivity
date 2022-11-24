//
//  SplashBuild.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 17/11/22.
//

import UIKit

class SplashBuild {
    
    static func build() -> UIViewController {
        let splashVC = SplashViewController()
        splashVC.router = SplashRouter(viewController: splashVC)
        return splashVC
    }
    
}
