//
//  PersonalSliderView.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import Foundation
import UIKit

enum PersonalSliderType {
    case age
    case height
    case weight
    
    var title: String? {
        switch self {
        case .age:
            return "Age"
        case .height:
            return "Height"
        case .weight:
            return "Weight"
        }
    }
    
    var isSwitchHidden: Bool {
        switch self {
        case .age:
            return true
        case .height, .weight:
            return false
        }
    }
}

class PersonalSliderView: BaseView {
    
    private var personalSliderType: PersonalSliderType
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(named: "blackLabel")
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = personalSliderType.title
        return label
    }()
    
    public init(type: PersonalSliderType) {
        self.personalSliderType = type
        super.init(frame: .zero)
        setupControl()
        setupComponentsUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupControl() {
        super.setupControl()
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
    }
    
}
