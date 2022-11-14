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
        imageView.image = UIImage(named: "walk")
        return imageView
    }()
    
    private lazy var graphView: BaseView = {
        let view = BaseView(frame: .zero)
        return view
    }()
    
    private lazy var circularView: CircularProgressView = {
        let view = CircularProgressView(frame: .zero, lineWidth: 11, rounded: true)
        view.backgroundColor = .clear
        view.trackColor = UIColor(named: "grayProgress") ?? .lightGray
        view.progressColor = UIColor(named: "purple") ?? .purple
        view.progress = 11
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
        label.textColor = UIColor(named: "blackLabel")
        return label
    }()
    
    private lazy var measureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "Steps"
        label.textColor = UIColor(named: "grayLabel")
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
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
        
        addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.top.equalTo(topLeftImageView.snp.bottom).offset(20)
            make.left.equalTo(snp.left).inset(20)
            make.right.equalTo(snp.right).inset(20)
            make.bottom.equalTo(snp.bottom).inset(20)
        }
        
        centerView.addSubview(measureStackView)
        measureStackView.snp.makeConstraints { make in
            make.center.equalTo(centerView.snp.center)
        }
        
//        addSubview(circularView)
//        circularView.snp.makeConstraints { make in
//            make.top.equalTo(topLeftImageView.snp.bottom).offset(14)
//            make.left.equalTo(snp.left).inset(14)
//            make.right.equalTo(snp.right).inset(14)
//            make.bottom.equalTo(snp.bottom).inset(14)
//        }
//
////        graphView.addSubview(circularView)
////        circularView.snp.makeConstraints { make in
////            make.edges.equalTo(graphView.snp.edges)
////        }
//
//        circularView.addSubview(measureStackView)
//        measureStackView.snp.makeConstraints { make in
//            make.center.equalTo(circularView.snp.center)
//        }
    }
    
}
