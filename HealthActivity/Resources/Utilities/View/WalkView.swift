//
//  WalkView.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit
import ComponentsUI

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
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.text = "3500"
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
