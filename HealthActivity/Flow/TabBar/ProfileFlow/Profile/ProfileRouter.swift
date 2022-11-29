//
//  ProfileRouter.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit

class ProfileRouter: BaseRouter {
    
    func navigateToPersonalInfo(delegate: PersonalInfoDelegate) {
        let personalInfoBuild = PersonalInfoBuild.build(delegate: delegate)
        push(viewController: personalInfoBuild)
    }
}
