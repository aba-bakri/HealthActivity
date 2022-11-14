//
//  ProfileRouter.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit

class ProfileRouter: BaseRouter {
    
    func navigateToPersonalInfo() {
        let personalInfoBuild = PersonalInfoBuild.build()
        push(viewController: personalInfoBuild)
    }
}
