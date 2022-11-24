//
//  BaseViewController.swift
//  ComponentsUI
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit
import SVProgressHUD

open class ViewController: UIViewController, Setupable {

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupControl()
        setupComponentsUI()
        bindUI()
        bindViewModel()
    }
    
    open func bindUI() { }
    
    open func bindViewModel() { }
    
    open func setupControl() { }
    
    open func setupComponentsUI() { }
    
    func showLoader() {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }

    func hideLoader() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
}
