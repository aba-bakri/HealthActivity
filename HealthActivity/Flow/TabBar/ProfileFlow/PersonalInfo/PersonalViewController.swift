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
    
    internal var router: PersonalRouter?
    internal var viewModel: PersonalInfoViewModel!
    
    let test = [Int](1...100)
    
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
        stackView.addArrangedSubview(heightView)
        stackView.addArrangedSubview(weightView)
//        stackView.addArrangedSubview(pickerView)
        return stackView
    }()
    
    private lazy var nextButton: BaseButton = {
        let button = BaseButton(frame: .zero)
        button.setTitle("Next", for: .normal)
        button.setCornerRadius(corners: .allCorners, radius: 25)
        button.backgroundColor = UIColor(named: "purple")
        return button
    }()
    
    private let nextButtonSubject = BehaviorSubject<Bool>(value: false)
    private let heightUnitSubject = BehaviorSubject<HKUnit>(value: .meter())
    private let weightUnitSubject = BehaviorSubject<HKUnit>(value: .pound())
    private let changeHeightSubject = PublishSubject<Int>()
    
//    private let heightUnitSubject = PublishSubject<HKUnit>()
//    private let weightUnitSubject = PublishSubject<HKUnit>()
//    private let changeHeightSubject = PublishSubject<Int>()
//    private let changeWeightSubject = PublishSubject<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupControl() {
        super.setupControl()
    }
    
    override func bindUI() {
        super.bindUI()
        
//        heightView.pickerView.rx.itemSelected.subscribe(onNext: { [weak self] row, component in
//            guard let self = self else { return }
//            self.changeHeightSubject.onNext(row)
//        }).disposed(by: disposeBag)
//
//        weightView.pickerView.rx.itemSelected.subscribe(onNext: { [weak self] row, component in
//            guard let self = self else { return }
////            self.changeHeightSubject.onNext(row)
//        }).disposed(by: disposeBag)
//
        
        
        heightView.rulerValueDidChange = { [weak self] value in
            guard let self = self else { return }
            self.changeHeightSubject.onNext(value.toInt() ?? .zero)
            self.nextButtonSubject.onNext(true)
        }
        
        nextButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        let input = PersonalInfoViewModel.Input(nextButton: nextButtonSubject.asObservable(),
                                                heightUnit: heightUnitSubject.asObservable(),
                                                weightUnit: weightUnitSubject.asObservable(),
                                                changeHeight: changeHeightSubject.asObservable())
        let output = viewModel.transform(input: input)
        
//        output.heightUnitSubject.drive(onNext: { [weak self] heightUnit in
//            guard let self = self else { return }
//            self.heightView.selectSegmentedControl(unit: heightUnit)
//        }).disposed(by: disposeBag)
//
//        output.heightValueSubjet.drive(onNext: { [weak self] heightValue in
//            guard let self = self else { return }
//            debugPrint("Debug__Test\(heightValue)")
//            self.heightView.selectValueRow(row: heightValue)
//        }).disposed(by: disposeBag)
        
        output.heightSubjet.drive(onNext: { [weak self] heightUnit, heightValue in
            guard let self = self else { return }
//            debugPrint("Debug__\(heightUnit), \(heightValue)")
            self.heightView.configureRulerView(scale: .integer(heightValue))
//            self.heightView.selectUnitControl(unit: heightUnit)
//            self.heightView.selectValueRow(row: heightValue)
        }).disposed(by: disposeBag)
        
        output.nextButtonSubject.drive(onNext: { [weak self] isEnabled in
            guard let self = self else { return }
            self.nextButton.isEnabled = isEnabled
        }).disposed(by: disposeBag)
        
//        output.weightSubject.drive(onNext: { [weak self] weightUnit, weightValue in
//            guard let self = self else { return }
////            self.weightView.selectUnitControl(unit: weightUnit)
////            self.weightView.selectValueRow(row: weightValue)
//        }).disposed(by: disposeBag)
        
//        nextButton.rx.tap.subscribe(onNext: { [weak self] _ in
//            guard let self = self else { return }
//
//        })
//        output.
    }
    
//    override func bindViewModel() {
//        super.bindViewModel()
//
//        let input = PersonalInfoViewModel.Input(heightUnit: heightUnitSubject.asObservable(),
//                                                weightUnit: weightUnitSubject.asObservable(),
//                                                changeHeight: changeHeightSubject.asObservable(),
//                                                changeWeight: changeWeightSubject.asObservable())
//        let output = viewModel.transform(input: input)
//
//        output.navigationTitle.drive(onNext: { [weak self] title in
//            guard let self = self else { return }
//            self.navigationItem.title = title
//        }).disposed(by: disposeBag)
//
//        output.heightSubject.drive(onNext: { [weak self] height in
//            guard let self = self else { return }
//            self.heightView.selectRow(row: height)
//        }).disposed(by: disposeBag)
//
//        output.weightSubject.drive(onNext: { [weak self] weight in
//            guard let self = self else { return }
//            self.weightView.selectRow(row: weight)
//        }).disposed(by: disposeBag)
//
//        output.errorSubject.drive(onNext: { [weak self] errorMessage in
//            guard let self = self else { return }
//            self.showErrorAlert(title: "Error", message: errorMessage)
//        }).disposed(by: disposeBag)
//
//        output.nextButtonIsEnabled.drive(onNext: { [weak self] isEnabled in
//            guard let self = self else { return }
//            self.nextButton.isEnabled = isEnabled
//        }).disposed(by: disposeBag)
//    }
    
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
    
    @objc private func testAction() { }
    
    @objc private func genderValueChanged() { }
}
