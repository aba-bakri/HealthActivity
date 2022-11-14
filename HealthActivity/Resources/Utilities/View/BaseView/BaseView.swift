//
//  BaseView.swift
//  ComponentsUI
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit
import SnapKit

open class BaseView: UIView, Setupable {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupControl()
        setupComponentsUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupControl() { }
    
    open func setupComponentsUI() { }
    
}
