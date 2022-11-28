//
//  PersonalViewController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit
import RxSwift
import HealthKit

class PersonalInfoViewController: BaseController {
    
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
        label.text = HealthManager.shared.getSex()
        return label
    }()
    
    private lazy var heightView: PersonalSliderView = {
        let view = PersonalSliderView(type: .height(unit: UserDefaultStorage.heightUnit))
        return view
    }()
    
    private lazy var weightView: PersonalSliderView = {
        let view = PersonalSliderView(type: .weight(unit: UserDefaultStorage.weightUnit))
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(heightView)
        stackView.addArrangedSubview(weightView)
        return stackView
    }()
    
    private lazy var nextButton: BaseButton = {
        let button = BaseButton(frame: .zero)
        button.setTitle("Next", for: .normal)
        button.setCornerRadius(corners: .allCorners, radius: 25)
        return button
    }()
    
    internal var router: PersonalRouter?
    internal var viewModel: PersonalInfoViewModel!
    private let saveSubject = PublishSubject<()>()
    private let heightUnitSubject = BehaviorSubject<HeightUnit>(value: UserDefaultStorage.heightUnit)
    private let weightUnitSubject = BehaviorSubject<WeightUnit>(value: UserDefaultStorage.weightUnit)
    
    private let changeHeightSubject = PublishSubject<Int>()
    private let changeWeightSubject = PublishSubject<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupControl() {
        super.setupControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindViewModel()
    }
    
    override func bindUI() {
        super.bindUI()
        
        heightView.rulerValueDidChange = { [weak self] value in
            guard let self = self else { return }
            self.changeHeightSubject.onNext(value.toInt() ?? .zero)
        }
        
        weightView.rulerValueDidChange = { [weak self] value in
            guard let self = self else { return }
            self.changeWeightSubject.onNext(value.toInt() ?? .zero)
        }
        
        nextButton.rx.tap.asDriver().drive(onNext: { _ in
            self.saveSubject.onNext(())
        }).disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        let input = PersonalInfoViewModel.Input(saveButton: saveSubject.asObservable(),
                                                heightUnit: heightUnitSubject.asObservable(),
                                                weightUnit: weightUnitSubject.asObservable(),
                                                changeHeight: changeHeightSubject.asObservable(),
                                                changeWeight: changeWeightSubject.asObservable())
        let output = viewModel.transform(input: input)
        
        output.heightSubjet.drive(onNext: { [weak self] heightUnit, heightValue in
            guard let self = self else { return }
            self.heightView.configureRulerView(value: heightValue)
            self.changeHeightSubject.onNext(heightValue)
        }).disposed(by: disposeBag)
        
        output.weightSubject.drive(onNext: { [weak self] weightUnit, weightValue in
            guard let self = self else { return }
            self.weightView.configureRulerView(value: weightValue)
            self.changeWeightSubject.onNext(weightValue)
        }).disposed(by: disposeBag)
        
        output.errorSubject.drive(onNext: { [weak self] error in
            guard let self = self else { return }
            self.showErrorAlert(title: "Error", message: error)
        }).disposed(by: disposeBag)
        
        output.saveSubject.drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.router?.pop()
        }).disposed(by: disposeBag)
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        
        contentView.addSubview(sexLabel)
        sexLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.left.equalTo(contentView.snp.left).inset(20)
        }
        
        contentView.addSubview(sexValueLabel)
        sexValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sexLabel.snp.centerY)
            make.right.equalTo(contentView.snp.right).inset(20)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(sexLabel.snp.bottom).offset(30)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
        }
        
        contentView.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(stackView.snp.bottom).offset(14)
            make.left.equalTo(contentView.snp.left).inset(14)
            make.right.equalTo(contentView.snp.right).inset(14)
            make.bottom.equalTo(contentView.snp.bottom).inset(14)
            make.height.equalTo(48)
        }
    }

}
