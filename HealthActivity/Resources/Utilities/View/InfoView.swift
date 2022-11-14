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
    
    var title: String? {
        switch self {
        case .sleep:
            return "Sleep"
        case .calories:
            return "Calories"
        }
    }
    
    var topLeftImage: UIImage? {
        switch self {
        case .sleep:
            return UIImage(named: "sleep")
        case .calories:
            return UIImage(named: "calories")
        }
    }
    
    var measure: String? {
        switch self {
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
        
        addSubview(topStackView)
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(14)
            make.left.equalTo(snp.left).inset(14)
        }
        
        topLeftImageView.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }

        addSubview(measureStackView)
        measureStackView.snp.makeConstraints { make in
            make.left.equalTo(snp.left).inset(14)
            make.bottom.equalTo(snp.bottom).inset(14)
        }
    }
}
