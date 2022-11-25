//
//  ProfileInfoView.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit

class ProfileInfoView: BaseView {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(named: "blackLabel")
        label.text = UserDefaultStorage.firstName
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(named: "grayLabel")
        label.text = UserDefaultStorage.email
        return label
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.spacing = 7
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(emailLabel)
        return stackView
    }()
    
    public lazy var moreButton: BaseClearButton = {
        let button = BaseClearButton(frame: .zero)
        button.setImage(UIImage(named: "more"), for: .normal)
        return button
    }()
    
    private lazy var dividerView: BaseView = {
        let view = BaseView(frame: .zero)
        view.backgroundColor = UIColor(named: "background")
        return view
    }()
    
    lazy var weightView: ProfileMeasureView = {
        let view = ProfileMeasureView(type: .weight)
        return view
    }()
    
    lazy var heightView: ProfileMeasureView = {
        let view = ProfileMeasureView(type: .height)
        return view
    }()
    
    lazy var ageView: ProfileMeasureView = {
        let view = ProfileMeasureView(type: .age)
        view.configureAgeView()
        return view
    }()
    
    private lazy var measureStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 14
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(weightView)
        stackView.addArrangedSubview(heightView)
        stackView.addArrangedSubview(ageView)
        return stackView
    }()
    
    override func setupControl() {
        super.setupControl()
        backgroundColor = .white
        setShadow(radius: 10)
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        
        addSubview(nameStackView)
        nameStackView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(28)
            make.left.equalTo(snp.left).offset(14)
        }
        
        addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(39)
            make.right.equalTo(snp.right).inset(16)
            make.width.height.equalTo(16)
        }
        
        addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(nameStackView.snp.bottom).offset(28)
            make.left.equalTo(snp.left).inset(14)
            make.right.equalTo(snp.right).inset(14)
            make.height.equalTo(1)
        }
        
        addSubview(measureStackView)
        measureStackView.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom).offset(13.5)
            make.left.equalTo(snp.left).inset(14)
            make.right.equalTo(snp.right).inset(14)
            make.bottom.equalTo(snp.bottom).inset(14)
        }
    }
    
}
