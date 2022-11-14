//
//  PersonalViewController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit

class PersonalInfoViewController: BaseController {
    
    internal var router: PersonalRouter?
    internal var viewModel: PersonalInfoViewModel!
    
    private lazy var sexLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(named: "blackLabel")
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "Sex"
        return label
    }()
    
    private lazy var sexValueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(named: "blackLabel")
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = HealthTest.shared.getSex()
        return label
    }()
    
//    private lazy var genderSegmentedControl: UISegmentedControl = {
//        let control = UISegmentedControl(items: ["Male", "Female", "Other"])
//        control.selectedSegmentTintColor = UIColor.white
//        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "segmentedGray") ?? .lightGray], for: .normal)
//        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "purple") ?? .purple], for: .selected)
//        control.selectedSegmentIndex = 1
//        control.addTarget(self, action: #selector(genderValueChanged), for: .valueChanged)
//        return control
//    }()
    
    private lazy var rightBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "notification"), style: .plain, target: self, action: #selector(testAction))
        return button
    }()
    
//    private lazy var ageView: PersonalSliderView = {
//        let view = PersonalSliderView(type: .age)
//        return view
//    }()
    
    private lazy var heightView: PersonalSliderView = {
        let view = PersonalSliderView(type: .height)
        return view
    }()
    
    private lazy var weightView: PersonalSliderView = {
        let view = PersonalSliderView(type: .weight)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
//        stackView.addArrangedSubview(ageView)
        stackView.addArrangedSubview(heightView)
        stackView.addArrangedSubview(weightView)
        return stackView
    }()
    
    private lazy var nextButton: BaseButton = {
        let button = BaseButton(frame: .zero)
        button.setTitle("Next", for: .normal)
        button.setCornerRadius(corners: .allCorners, radius: 25)
        button.backgroundColor = UIColor(named: "purple")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.title = "Personal Info"
    }
    
    override func setupControl() {
        super.setupControl()
        
//        HealthTest.shared.changeHeight(height: 70, date: Date()) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success:
//                break
//            case .failure(let error):
//                self.showErrorAlert(message: error)
//            }
//        }
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = PersonalInfoViewModel.Input()
        let output = viewModel.transform(input: input)
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        
        contentView.addSubview(sexLabel)
        sexLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(14)
            make.left.equalTo(contentView.snp.left).inset(14)
        }
        
//        contentView.addSubview(sexValueLabel)
//        sexValueLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(sexLabel.snp.centerY)
//            make.right.equalTo(contentView.snp.right).inset(14)
//        }
        
        contentView.addSubview(sexValueLabel)
        sexValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sexLabel.snp.centerY)
            make.right.equalTo(contentView.snp.right).inset(14)
        }
        
//        contentView.addSubview(stackView)
//        stackView.snp.makeConstraints { make in
//            make.top.equalTo(sexLabel.snp.bottom).offset(30)
//            make.left.equalTo(contentView.snp.left).inset(14)
//            make.right.equalTo(contentView.snp.right).inset(14)
//        }
//
//        [heightView, weightView].forEach { view in
//            view.snp.makeConstraints { make in
//                make.height.equalTo(160)
//            }
//        }
//
//        contentView.addSubview(nextButton)
//        nextButton.snp.makeConstraints { make in
//            make.top.greaterThanOrEqualTo(stackView.snp.bottom).offset(14)
//            make.left.equalTo(contentView.snp.left).inset(14)
//            make.right.equalTo(contentView.snp.right).inset(14)
//            make.bottom.equalTo(contentView.snp.bottom).inset(14)
//            make.height.equalTo(48)
//        }
        
    }
    
    @objc private func testAction() { }
    
    @objc private func genderValueChanged() {
        
    }
}
