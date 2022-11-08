//
//  BaseNavigationController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit
import ComponentsUI

open class BaseNavigationController: UINavigationController, Setupable {

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupControl()
        setupComponentsUI()
    }
    
    open func setupControl() {
        navigationBar.barStyle = .default
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = UIColor(named: "background")
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "blackLabel") ?? .black, .font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
        navigationBar.tintColor = UIColor(named: "blackLabel")
        navigationBar.barStyle = .default
    }
    
    open func setupComponentsUI() { }

}
