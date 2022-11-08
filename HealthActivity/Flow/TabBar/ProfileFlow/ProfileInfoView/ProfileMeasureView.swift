//
//  ProfileMeasureView.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import ComponentsUI
import UIKit

enum ProfileMeasureType {
    case weight(value: String)
    case height(value: String)
    case age(value: String)
    
    var title: String? {
        switch self {
        case .weight:
            return "Weight"
        case .height:
            return "Height"
        case .age:
            return "Age"
        }
    }
    
    var value: String {
        switch self {
        case .weight(let value):
            return "\(value) Kg"
        case .height(let value):
            return "\(value) ”Ft"
        case .age(let value):
            return "\(value) Yrs"
        }
    }
}

class ProfileMeasureView: BaseView {
    
    private var measureType: ProfileMeasureType
    
    private lazy var measureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "grayLabel")
        label.text = measureType.title
        return label
    }()
    
    private lazy var measureValueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "grayLabel")
        label.text = measureType.value
        return label
    }()
    
    private lazy var measureStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(measureLabel)
        stackView.addArrangedSubview(measureValueLabel)
        return stackView
    }()
    
    public init(type: ProfileMeasureType) {
        self.measureType = type
        super.init(frame: .zero)
        setupControl()
        setupComponentsUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupControl() {
        super.setupControl()
        backgroundColor = .white
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        addSubview(measureStackView)
        measureStackView.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
        }
    }
    
    func configureView(model: String) {
//        let warningTitle = NSMutableAttributedString(string: R.string.authLocalizable.federatedWarningTitle())
//        let boldAttribute = [NSAttributedString.Key.font: SHFontPreset.subheadlineBold]
//        let boldAttributedString = NSAttributedString(string: "\n\(R.string.authLocalizable.federatedWarningSubtitle())", attributes: boldAttribute)
//        warningTitle.append(boldAttributedString)
//        warningLabel.attributedText = warningTitle
    }
}
