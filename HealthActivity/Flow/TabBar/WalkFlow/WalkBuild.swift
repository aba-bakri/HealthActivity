//
//  WalkBuild.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 26/11/22.
//

import UIKit

class WalkBuild {
    static func build() -> UIViewController {
        let walkViewController = WalkViewController()
        walkViewController.router = WalkRouter(viewController: walkViewController)
        walkViewController.viewModel = WalkViewModel()
        return walkViewController
    }
}
