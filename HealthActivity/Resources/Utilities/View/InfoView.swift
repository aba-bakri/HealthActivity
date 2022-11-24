//
//  InfoView.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit
import SnapKit

enum InfoType {
    case sleep
    case calories
    case walk
    case heart
    
    var title: String? {
        switch self {
        case .walk:
            return "Walk"
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
        case .walk:
            return UIImage(named: "walk")
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
        case .walk:
            return "Steps"
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
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = infoType.title
        label.textColor = UIColor(named: "blackLabel")
        return label
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 14
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(topLeftImageView)
        stackView.addArrangedSubview(titleLabel)
        return stackView
    }()
    
    private lazy var measureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = infoType.measure
        label.textColor = UIColor(named: "grayLabel")
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
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
    
    private lazy var generalStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(topStackView)
        stackView.addArrangedSubview(measureStackView)
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
        
        addSubview(generalStackView)
        generalStackView.snp.makeConstraints { make in
            make.edges.equalTo(snp.edges).inset(14)
        }
        
        topLeftImageView.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
    }
    
    func configureValueLabel(value: Int) {
        if value == .zero {
            valueLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            valueLabel.text = "Haven't measured today"
        } else {
            valueLabel.text = value.toString
        }
    }
    
}
