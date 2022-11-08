//
//  InfoView.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit
import ComponentsUI
import SnapKit

enum InfoType {
    case water
    case heart
    case sleep
    case calories
    
    var title: String? {
        switch self {
        case .water:
            return "Water"
        case .heart:
            return "Heart"
        case .sleep:
            return "Sleep"
        case .calories:
            return "Calories"
        }
    }
    
    var topLeftImage: UIImage? {
        switch self {
        case .water:
            return UIImage(named: "water")
        case .heart:
            return UIImage(named: "heart")
        case .sleep:
            return UIImage(named: "sleep")
        case .calories:
            return UIImage(named: "calories")
        }
    }
    
    var measure: String? {
        switch self {
        case .water:
            return "Liters"
        case .heart:
            return "BPM"
        case .sleep:
            return "Hours"
        case .calories:
            return "Kcal"
        }
    }
}

class InfoView: BaseView {
    
    private lazy var topLeftImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = infoType.topLeftImage
        return imageView
    }()
    
    private lazy var graphView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = infoType.title
        label.textColor = UIColor(named: "blackLabel")
        return label
    }()
    
    private lazy var measureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = infoType.measure
        label.textColor = UIColor(named: "grayLabel")
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = "0.10"
        label.textColor = UIColor(named: "blackLabel")
        return label
    }()
    
    private lazy var measureStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.addArrangedSubview(measureLabel)
        stackView.addArrangedSubview(valueLabel)
        return stackView
    }()
    
    private var infoType: InfoType
    
    public init(type: InfoType) {
        self.infoType = type
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
        setShadow(radius: 10)
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        
        addSubview(topLeftImageView)
        topLeftImageView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(16)
            make.left.equalTo(snp.left).inset(16)
            make.height.width.equalTo(44)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(topLeftImageView.snp.right).offset(16)
            make.centerY.equalTo(topLeftImageView.snp.centerY)
        }
        
        addSubview(graphView)
        graphView.snp.makeConstraints { make in
            make.top.equalTo(topLeftImageView.snp.bottom).offset(14)
            make.left.equalTo(topLeftImageView.snp.left).inset(14)
            make.right.equalTo(topLeftImageView.snp.right).inset(14)
            make.height.greaterThanOrEqualTo(100)
        }
        
        addSubview(measureStackView)
        measureStackView.snp.makeConstraints { make in
            make.top.equalTo(graphView.snp.bottom).offset(14)
            make.left.equalTo(snp.left).inset(14)
            make.bottom.equalTo(snp.bottom).inset(14)
        }
    }
}
