//
//  ActivityView.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 10/11/22.
//

import UIKit

class ActivityView: BaseView {
    
    private lazy var topLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Steps"
        label.textColor = UIColor(named: "grayLabel")
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var stepLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 80, weight: .medium)
        label.textColor = UIColor(named: "blackLabel")
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "grayLabel")
        label.text = "Distance"
        return label
    }()
    
    lazy var distanceValueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(named: "blackLabel")
        return label
    }()
    
    private lazy var distanceStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.addArrangedSubview(distanceLabel)
        stackView.addArrangedSubview(distanceValueLabel)
        return stackView
    }()
    
    private lazy var caloriesLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "grayLabel")
        label.text = "Calories"
        return label
    }()
    
    lazy var caloriesValueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(named: "blackLabel")
        return label
    }()
    
    private lazy var caloriesStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.addArrangedSubview(caloriesLabel)
        stackView.addArrangedSubview(caloriesValueLabel)
        return stackView
    }()
    
    private lazy var pointsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "grayLabel")
        label.text = "Points"
        return label
    }()
    
    lazy var pointsValueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(named: "blackLabel")
        return label
    }()
    
    private lazy var pointsStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.addArrangedSubview(pointsLabel)
        stackView.addArrangedSubview(pointsValueLabel)
        return stackView
    }()
    
    private lazy var measureStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.spacing = 14
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(distanceStackView)
        stackView.addArrangedSubview(caloriesStackView)
        stackView.addArrangedSubview(pointsStackView)
        return stackView
    }()
    
    override func setupControl() {
        super.setupControl()
        backgroundColor = UIColor.white
        setCornerRadius(corners: .allCorners, radius: 10)
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        
        addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(14)
            make.centerX.equalTo(snp.centerX)
        }
        addSubview(stepLabel)
        stepLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(7)
            make.centerX.equalTo(topLabel.snp.centerX)
        }
        
        addSubview(measureStackView)
        measureStackView.snp.makeConstraints { make in
            make.top.equalTo(stepLabel.snp.bottom).offset(30)
            make.left.equalTo(snp.left).inset(14)
            make.right.equalTo(snp.right).inset(14)
        }
        
    }
    
}
