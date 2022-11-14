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
    
    private lazy var walkView: WalkView = {
        let view = WalkView(frame: .zero)
        return view
    }()
    
    private lazy var sleepView: InfoView = {
        let view = InfoView(type: .sleep)
        return view
    }()

    private lazy var caloriesView: InfoView = {
        let view = InfoView(type: .calories)
        return view
    }()
    
    private lazy var heartView: InfoGraphView = {
        let view = InfoGraphView(type: .heart)
        return view
    }()
    
    private lazy var leftStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(sleepView)
        stackView.addArrangedSubview(heartView)
        return stackView
    }()
    
    private lazy var rightStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(walkView)
        stackView.addArrangedSubview(caloriesView)
        return stackView
    }()
    
    private lazy var generalStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 14
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(leftStackView)
        stackView.addArrangedSubview(rightStackView)
        return stackView
    }()
    
    private lazy var rightBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "notification"), style: .plain, target: self, action: #selector(testAction))
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.title = "Profile"
    }

    override func setupControl() {
        super.setupControl()
        
        profileInfoView.moreButton.didTapBlock = { [weak self] in
            guard let self = self else { return }
            self.router?.navigateToPersonalInfo()
        }
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = ProfileViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.walkSubject.drive(onNext: { [weak self] steps in
            guard let self = self else { return }
            self.walkView.valueLabel.text = steps.toString
        }).disposed(by: disposeBag)
        
        output.weightSubject.drive(onNext: { [weak self] weight in
            guard let self = self else { return }
            self.profileInfoView.weightView.measureValueLabel.text = weight.toString
        }).disposed(by: disposeBag)
        
        output.weightSubject.drive(onNext: { [weak self] height in
            guard let self = self else { return }
            self.profileInfoView.heightView.measureValueLabel.text = height.toString
        }).disposed(by: disposeBag)
        
        output.sleepSubject.drive(onNext: { [weak self] sleepHours in
            guard let self = self else { return }
            self.sleepView.valueLabel.text = sleepHours
        }).disposed(by: disposeBag)
        
        output.caloriesSubject.drive(onNext: { [weak self] calories in
            guard let self = self else { return }
            self.caloriesView.valueLabel.text = calories.toString
        }).disposed(by: disposeBag)
        
        profileInfoView.ageView.measureValueLabel.text = HealthTest.shared.getAge()
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
        
        contentView.addSubview(generalStackView)
        generalStackView.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(20)
            make.left.equalTo(contentView.snp.left).inset(14)
            make.right.equalTo(contentView.snp.right).inset(14)
            make.bottom.equalTo(contentView.snp.bottom).inset(14)
        }

        [heartView, walkView].forEach { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(244)
            }
        }

        [sleepView, caloriesView].forEach { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(145)
            }
        }
    }
    
    @objc private func testAction() { }
    
}
