//
//  BaseButton.swift
//  ComponentsUI
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit

open class BaseButton: BaseClearButton {
    
    open override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? R.color.purple() : R.color.purple()?.withAlphaComponent(0.5)
            isUserInteractionEnabled = isEnabled ? true : false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupControl()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupControl() {
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        self.backgroundColor = R.color.purple()
        self.setCornerRadius(corners: .allCorners, radius: 24)
    }
}
