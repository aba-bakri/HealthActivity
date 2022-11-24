//
//  ProfileMeasureView.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit
import RxCocoa

enum ProfileMeasureType {
    case weight
    case height
    case age
    
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
    
    var measure: String {
        switch self {
        case .weight:
            return " Kg"
        case .height:
            return " ”Ft"
        case .age:
            return " Yrs"
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
    
    lazy var measureValueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(named: "blackLabel")
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
    
    func configureView(value: String) {
        let boldAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold),
                             NSAttributedString.Key.foregroundColor: UIColor(named: "blackLabel")]
        let measureAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                             NSAttributedString.Key.foregroundColor: UIColor(named: "grayLabel")]
        let boldAttributedString = NSMutableAttributedString(string: value, attributes: boldAttribute as [NSAttributedString.Key: Any])
        let measureAttributedString = NSMutableAttributedString(string: measureType.measure, attributes: measureAttribute as [NSAttributedString.Key: Any])
        boldAttributedString.append(measureAttributedString)
        measureValueLabel.attributedText = boldAttributedString
    }
}
