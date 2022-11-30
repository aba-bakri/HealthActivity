//
//  InfoGraphView.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit
import SnapKit

enum InfoGraphType {
    case water
    case heart
    
    var title: String? {
        switch self {
        case .water:
            return "Water"
        case .heart:
            return "Heart"
        }
    }
    
    var topLeftImage: UIImage? {
        switch self {
        case .water:
            return R.image.water()
        case .heart:
            return R.image.heart()
        }
    }
    
    var measure: String? {
        switch self {
        case .water:
            return "Liters"
        case .heart:
            return "BPM"
        }
    }
}

class InfoGraphView: BaseView {
    
    private lazy var topLeftImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = infoGraphType.topLeftImage
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = infoGraphType.title
        label.textColor = R.color.blackLabel()
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
    
    private lazy var graphView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = R.color.purple()
        return view
    }()
    
    private lazy var measureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = infoGraphType.measure
        label.textColor = R.color.grayLabel()
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = R.color.blackLabel()
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
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(topStackView)
        stackView.addArrangedSubview(graphView)
        stackView.addArrangedSubview(measureStackView)
        return stackView
    }()
    
    private var infoGraphType: InfoGraphType
    
    public init(type: InfoGraphType) {
        self.infoGraphType = type
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
            make.height.equalTo(44)
        }

        addSubview(graphView)
        graphView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(14)
            make.left.equalTo(snp.left).inset(14)
            make.right.equalTo(snp.right).inset(14)
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
