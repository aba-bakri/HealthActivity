//
//  ProfileViewController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit
import HealthKit

class ProfileViewController: BaseController {
    
    internal var router: ProfileRouter?
    internal var viewModel: ProfileViewModel!
    
    private lazy var profileInfoView: ProfileInfoView = {
        let view = ProfileInfoView(frame: .zero)
        return view
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = UIColor(named: "blackLabel")
        label.text = "Today"
        return label
    }()
    
    private lazy var walkView: InfoView = {
        let view = InfoView(type: .walk)
        return view
    }()
    
    private lazy var heartView: InfoView = {
        let view = InfoView(type: .heart)
        return view
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 14
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(walkView)
        stackView.addArrangedSubview(heartView)
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
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 14
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(sleepView)
        stackView.addArrangedSubview(caloriesView)
        return stackView
    }()
    
    private lazy var leftBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "notification"), style: .plain, target: self, action: #selector(notificationAction))
        return button
    }()
    
    private lazy var rightBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(settingsAction))
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }

    override func setupControl() {
        super.setupControl()
        
        profileInfoView.moreButton.didTapBlock = { [weak self] in
            guard let self = self else { return }
            self.router?.navigateToPersonalInfo()
        }
    }
    
    override func bindUI() {
        super.bindUI()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = ProfileViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.navigationTitleSubject.drive(onNext: { [weak self] title in
            guard let self = self else { return }
            self.navigationItem.title = title
        }).disposed(by: disposeBag)
        
        output.walkSubject.drive(onNext: { [weak self] steps in
            guard let self = self else { return }
            self.walkView.valueLabel.text = steps.toString
        }).disposed(by: disposeBag)
        
        output.heightSubject.drive(onNext: { [weak self] height in
            guard let self = self else { return }
            self.profileInfoView.heightView.configureView(value: height.toString)
        }).disposed(by: disposeBag)
         
        output.weightSubject.drive(onNext: { [weak self] weight in
            guard let self = self else { return }
            self.profileInfoView.weightView.configureView(value: weight.toString)
        }).disposed(by: disposeBag)
        
        output.sleepSubject.drive(onNext: { [weak self] sleepHours in
            guard let self = self else { return }
            self.sleepView.valueLabel.text = sleepHours
        }).disposed(by: disposeBag)
        
        output.caloriesSubject.drive(onNext: { [weak self] calories in
            guard let self = self else { return }
            self.caloriesView.valueLabel.text = calories.toString
        }).disposed(by: disposeBag)
        
        output.heartRateSubject.drive(onNext: { [weak self] heartRate in
            guard let self = self else { return }
            self.heartView.configureValueLabel(value: heartRate)
        }).disposed(by: disposeBag)
        
        profileInfoView.ageView.configureView(value: HealthManager.shared.getAge())
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        contentView.addSubview(profileInfoView)
        profileInfoView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(14)
            make.left.equalTo(contentView.snp.left).inset(14)
            make.right.equalTo(contentView.snp.right).inset(14)
            make.height.equalTo(193)
        }
        
        contentView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(profileInfoView.snp.bottom).offset(30)
            make.left.equalTo(contentView.snp.left).inset(14)
        }
        
        contentView.addSubview(topStackView)
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(20)
            make.left.equalTo(contentView.snp.left).inset(14)
            make.right.equalTo(contentView.snp.right).inset(14)
        }
        
        contentView.addSubview(bottomStackView)
        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(14)
            make.left.equalTo(contentView.snp.left).inset(14)
            make.right.equalTo(contentView.snp.right).inset(14)
            make.bottom.equalTo(contentView.snp.bottom).inset(14)
        }

        [walkView, heartView, sleepView, caloriesView].forEach { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(145)
            }
        }
    }
    
    @objc private func notificationAction() {
        
    }
    
    @objc private func settingsAction() {
        
    }
    
}
