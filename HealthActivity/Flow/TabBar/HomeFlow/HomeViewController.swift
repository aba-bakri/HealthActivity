//
//  HomeViewController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit
import ComponentsUI

class HomeViewController: BaseController {
    
    internal var router: HomeRouter?
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = UIColor(named: "blackLabel")
        label.text = "Welcome, Back!"
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(named: "grayLabel")
        label.text = "Hi, Aba-Bakri"
        return label
    }()
    
    private lazy var welcomeStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.addArrangedSubview(welcomeLabel)
        stackView.addArrangedSubview(nameLabel)
        return stackView
    }()
    
    private lazy var walkView: WalkView = {
        let view = WalkView(frame: .zero)
        return view
    }()
    
    private lazy var waterView: InfoView = {
        let view = InfoView(type: .water)
        return view
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 14
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(walkView)
        stackView.addArrangedSubview(waterView)
        return stackView
    }()
    
    private lazy var sleepView: InfoView = {
        let view = InfoView(type: .sleep)
        return view
    }()
    
    private lazy var caloriesView: InfoView = {
        let view = InfoView(type: .calories)
        return view
    }()
    
    private lazy var rightStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(sleepView)
        stackView.addArrangedSubview(caloriesView)
        return stackView
    }()
    
    private lazy var heartView: InfoView = {
        let view = InfoView(type: .heart)
        return view
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 14
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(heartView)
        stackView.addArrangedSubview(rightStackView)
        return stackView
    }()
    
    private lazy var generalStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(topStackView)
        stackView.addArrangedSubview(bottomStackView)
        return stackView
    }()
    
    private lazy var leftBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(testAction))
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.title = "Home"
    }

    override func setupControl() {
        super.setupControl()
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        contentView.addSubview(welcomeStackView)
        welcomeStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(30)
            make.left.equalTo(contentView.snp.left).inset(14)
        }

        contentView.addSubview(topStackView)
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(welcomeStackView.snp.bottom).offset(30)
            make.left.equalTo(contentView.snp.left).inset(14)
            make.right.equalTo(contentView.snp.right).inset(14)
            make.height.equalTo(244)
        }
        
        contentView.addSubview(bottomStackView)
        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(14)
            make.left.equalTo(contentView.snp.left).inset(14)
            make.right.equalTo(contentView.snp.right).inset(14)
            make.bottom.equalTo(contentView.snp.bottom).inset(14)
            make.height.equalTo(304)
        }
//        contentView.addSubview(generalStackView)
//        generalStackView.snp.makeConstraints { make in
//            make.top.equalTo(welcomeStackView.snp.bottom).offset(30)
//            make.left.equalTo(contentView.snp.left).inset(14)
//            make.right.equalTo(contentView.snp.right).inset(14)
//            make.bottom.greaterThanOrEqualTo(contentView.snp.bottom).inset(14)
//        }
//
        [sleepView, caloriesView].forEach { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(145)
            }
        }
    }
    
    @objc private func testAction() { }
    
}
