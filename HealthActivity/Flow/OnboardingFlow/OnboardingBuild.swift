//
//  OnboardingBuild.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 19/11/22.
//

import UIKit

class OnboardingBuild {
    
    static func build(delegate: OnboardingDelegate) -> UIViewController {
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.delegate = delegate
        onboardingViewController.router = OnboardingRouter(viewController: onboardingViewController)
        onboardingViewController.viewModel = OnboardingViewModel()
        return onboardingViewController
    }
    
}
