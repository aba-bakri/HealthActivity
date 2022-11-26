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
    
    static func getMainTabBarController() -> BaseNavigationController {
        let build = MainTabBarBuild.build()
        return BaseNavigationController(rootViewController: build)
    }
    
    static func loadOnboardingController(delegate: OnboardingDelegate) -> BaseNavigationController {
        let build = OnboardingBuild.build(delegate: delegate)
        return BaseNavigationController(rootViewController: build)
    }
}
