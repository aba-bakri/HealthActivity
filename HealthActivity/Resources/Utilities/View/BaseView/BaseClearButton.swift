//
//  BaseClearButton.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 19/11/22.
//

import UIKit

open class BaseClearButton: UIButton, Tapable {
    
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
