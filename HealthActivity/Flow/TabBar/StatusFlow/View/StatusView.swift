//
//  StatusView.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 10/11/22.
//

import UIKit

enum StatusType {
    case heart
    case sleep
    
    var image: UIImage? {
        switch self {
        case .heart:
            return R.image.heart()
        case .sleep:
            return R.image.sleep()
        }
    }
    
    var title: String? {
        switch self {
        case .heart:
            return "Heart Beat"
        case .sleep:
            return "Sleep"
        }
    }
    
    var measure: String? {
        switch self {
        case .heart:
            return "BPM"
        case .sleep:
            return "Hours"
        }
    }
    
    var progressLineColor: UIColor? {
        switch self {
        case .heart:
            return R.color.purple()
        case .sleep:
            return R.color.green()
        }
    }
    
    var maxValue: Double {
        switch self {
        case .heart:
            return 220
        case .sleep:
            return 8
        }
    }
}

class StatusView: BaseView {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = statusType.image
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = statusType.title
        label.textColor = R.color.blackLabel()
        return label
    }()
    
    private lazy var measureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = statusType.measure
        label.textColor = R.color.grayLabel()
        return label
    }()
    
    private lazy var measureValueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = statusType.measure
        label.textColor = R.color.blackLabel()
        return label
    }()
    
    private lazy var measureStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.spacing = 9
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(measureLabel)
        stackView.addArrangedSubview(measureValueLabel)
        return stackView
    }()
    
    private lazy var statusProgressView: StatusProgressView = {
        let view = StatusProgressView(type: statusType)
        return view
    }()
    
    private lazy var previousWeekLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = R.color.blackLabel()
        label.text = "Previous week"
        return label
    }()
    
    private lazy var bottomMeasureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = statusType.measure
        label.textColor = R.color.grayLabel()
        return label
    }()
    
    lazy var bottomMeasureValueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = statusType.measure
        label.textColor = R.color.blackLabel()
        return label
    }()
    
    private lazy var bottomMeasureStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.spacing = 9
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(bottomMeasureLabel)
        stackView.addArrangedSubview(bottomMeasureValueLabel)
        return stackView
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = R.color.blackLabel()
        return label
    }()
    
    private var statusType: StatusType
    
    public init(type: StatusType) {
        self.statusType = type
        super.init(frame: .zero)
        setupControl()
        setupComponentsUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupControl() {
        super.setupControl()
        backgroundColor = UIColor.white
        setCornerRadius(corners: .allCorners, radius: 10)
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(14)
            make.left.equalTo(snp.left).inset(14)
            make.width.height.equalTo(44)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(imageView.snp.centerY)
            make.left.equalTo(imageView.snp.right).offset(14)
        }
        
        addSubview(measureStackView)
        measureStackView.snp.makeConstraints { make in
            make.centerY.equalTo(imageView.snp.centerY)
            make.right.equalTo(snp.right).inset(14)
        }
        
        addSubview(statusProgressView)
        statusProgressView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(14)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.height.equalTo(200)
        }
        
        addSubview(previousWeekLabel)
        previousWeekLabel.snp.makeConstraints { make in
            make.top.equalTo(statusProgressView.snp.bottom).offset(32)
            make.left.equalTo(snp.left).inset(28)
            make.bottom.equalTo(snp.bottom).inset(30)
        }
        
        addSubview(bottomMeasureStackView)
        bottomMeasureStackView.snp.makeConstraints { make in
            make.centerY.equalTo(previousWeekLabel.snp.centerY)
            make.right.equalTo(snp.right).inset(28)
        }
        
        addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
        }
    }
    
    func configureView(values: [StatusProgressModel?]) {
        let sortedValues = values.sorted(by: { ($0?.day ?? Date()).compare($1?.day ?? Date()) == .orderedAscending })
        statusProgressView.setupCollectionView(items: sortedValues)
    }
    
    func configureTodayLabel(value: String) {
        measureValueLabel.text = value
    }
}
