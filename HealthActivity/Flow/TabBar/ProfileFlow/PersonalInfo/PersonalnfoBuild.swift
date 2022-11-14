//
//  PersonalnfoBuild.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit

class PersonalInfoBuild {
    
    static func build() -> UIViewController {
        let personalInfoVC = PersonalInfoViewController()
        personalInfoVC.router = PersonalRouter(viewController: personalInfoVC)
        personalInfoVC.viewModel = PersonalInfoViewModel()
        personalInfoVC.hidesBottomBarWhenPushed = true
        return personalInfoVC
    }
}
