//
//  BaseButton.swift
//  ComponentsUI
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit

open class BaseButton: UIButton, Tapable {
    
    // MARK: Tapable
    public var didTapBlock: TapBlock? {
        didSet {
            self.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapAction() {
        didTapBlock?()
    }
}
