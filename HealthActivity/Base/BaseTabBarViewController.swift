//
//  BaseTabBarViewController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit

open class BaseTabBarViewController: UITabBarController, Setupable {

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupControl()
        setupComponentsUI()
    }
    
    open func setupControl() { }
    
    open func setupComponentsUI() { }

}
