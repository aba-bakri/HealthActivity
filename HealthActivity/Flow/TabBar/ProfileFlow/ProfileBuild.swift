//
//  ProfileBuild.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit

class ProfileBuild {
    
    static func build() -> UIViewController  {
        let homeVC = ProfileViewController()
        homeVC.router = ProfileRouter(viewController: homeVC)
        return homeVC
    }
}
