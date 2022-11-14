//
//  BaseViewController.swift
//  ComponentsUI
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit

open class BaseViewController: UIViewController, Setupable {

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupControl()
        setupComponentsUI()
        bindViewModel()
    }
    
    open func bindViewModel() { }
    
    open func setupControl() { }
    
    open func setupComponentsUI() { }
    
}
