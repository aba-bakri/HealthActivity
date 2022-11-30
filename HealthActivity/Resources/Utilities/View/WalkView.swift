//
//  WalkView.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit

class WalkView: BaseView {
    
    private lazy var topLeftImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = R.image.walk()
        return imageView
    }()
    
    private lazy var graphView: BaseView = {
        let view = BaseView(frame: .zero)
        return view
    }()
    
    lazy var circularView: CircularProgressView = {
        let view = CircularProgressView(frame: CGRect(x: .zero, y: .zero, width: 140, height: 140), lineWidth: 11, rounded: true)
        view.trackColor = R.color.grayProgress() ?? .lightGray
        view.progressColor = R.color.purple() ?? .purple
        return view
    }()
    
    private lazy var centerView: BaseView = {
        let view = BaseView(frame: .zero)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = "Walk"
        label.textColor = R.color.blackLabel()
        return label
    }()
    
    private lazy var measureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "Steps"
        label.textColor = R.color.grayLabel()
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textColor = R.color.blackLabel()
        return label
    }()
    
    private lazy var measureStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(measureLabel)
        stackView.addArrangedSubview(valueLabel)
        return stackView
    }()
    
    override func setupControl() {
        super.setupControl()
        backgroundColor = UIColor.white
        setShadow(radius: 10)
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        
        addSubview(topLeftImageView)
        topLeftImageView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(14)
            make.left.equalTo(snp.left).inset(14)
            make.width.height.equalTo(44)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(topLeftImageView.snp.right).offset(16)
            make.centerY.equalTo(topLeftImageView.snp.centerY)
        }
        
        addSubview(circularView)
        circularView.snp.makeConstraints { make in
            make.top.equalTo(topLeftImageView.snp.bottom).offset(14)
            make.left.equalTo(snp.left).inset(14)
            make.right.equalTo(snp.right).inset(14)
            make.bottom.equalTo(snp.bottom).inset(14)
            make.height.width.equalTo(140)
        }
        
        circularView.addSubview(measureStackView)
        measureStackView.snp.makeConstraints { make in
            make.center.equalTo(circularView.snp.center)
        }
    }
    
}
