//
//  HomeBuild.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit

class HomeBuild {
    
    static func build() -> UIViewController  {
        let homeVC = HomeViewController()
        homeVC.router = HomeRouter(viewController: homeVC)
        homeVC.viewModel = HomeViewModel()
        return homeVC
    }
}
