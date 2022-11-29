//
//  BaseNavigationController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit

open class BaseNavigationController: UINavigationController, Setupable {

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupControl()
        setupComponentsUI()
    }
    
    open func setupControl() {
        navigationBar.barStyle = .default
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = R.color.background()
        navigationBar.titleTextAttributes = [.foregroundColor: R.color.blackLabel() ?? .black, .font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
        navigationBar.tintColor = R.color.blackLabel()
        navigationBar.barStyle = .default
    }
    
    open func setupComponentsUI() { }

}
