//
//  AppBuilder.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 17/11/22.
//

import UIKit

class AppBuilder {
    
    static func loadSplashController() -> UIViewController {
        let controller = SplashViewController()
        return UINavigationController(rootViewController: controller)
    }
    
    static func getMainTabBarController() -> UINavigationController {
        let build = MainTabBarBuild.build()
        return UINavigationController(rootViewController: build)
    }
    
    static func loadOnboardingController(delegate: OnboardingDelegate) -> UINavigationController {
        let build = OnboardingBuild.build(delegate: delegate)
        return UINavigationController(rootViewController: build)
    }
}
