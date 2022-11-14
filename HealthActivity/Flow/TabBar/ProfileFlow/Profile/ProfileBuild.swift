//
//  ProfileBuild.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit

class ProfileBuild {
    
    static func build() -> UIViewController  {
        let profileVC = ProfileViewController()
        profileVC.viewModel = ProfileViewModel()
        profileVC.router = ProfileRouter(viewController: profileVC)
        return profileVC
    }
}
