//
//  WalkViewController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 26/11/22.
//

import UIKit
import RxCocoa
import RxSwift

class WalkViewController: BaseController {
    
    internal var router: WalkRouter?
    internal var viewModel: WalkViewModel!
    
    private lazy var circularProgressView: CircularProgressView = {
        let view = CircularProgressView(frame: CGRect(x: .zero, y: .zero, width: 320, height: 320), lineWidth: 11, rounded: true)
        view.progressColor = R.color.purple() ?? UIColor.purple
        view.trackColor = UIColor.lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    private lazy var stepLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = R.color.purple()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var outOfLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = R.color.grayLabel()
        label.text = "out of"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var goalStepLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = R.color.blackLabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(stepLabel)
        stackView.addArrangedSubview(outOfLabel)
        stackView.addArrangedSubview(goalStepLabel)
        return stackView
    }()
    
    private lazy var changeGoalTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = "Step goal"
        textField.tintColor = R.color.purple()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var saveButton: BaseButton = {
        let button = BaseButton(frame: .zero)
        button.setTitle("Save", for: .normal)
        return button
    }()
    
    private let dateSubject = BehaviorSubject<Date>(value: Date())
    private let goalStepSubject = BehaviorSubject<Int>(value: UserDefaultStorage.stepGoal)
    private let changeGoalSubject = BehaviorSubject<Int>(value: UserDefaultStorage.stepGoal)
    private let saveButtonSubject = PublishSubject<()>()

    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboard()
    }
    
    override func bindUI() {
        super.bindUI()
        
        changeGoalTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.changeGoalSubject.onNext(text.toInt() ?? .zero)
        }).disposed(by: disposeBag)
        
        changeGoalTextField.rx.controlEvent(.editingChanged).subscribe(onNext: { [unowned self] in
            if let text = self.changeGoalTextField.text {
                self.changeGoalTextField.text = String(text.prefix(5))
            }
        }).disposed(by: disposeBag)
        
        saveButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.saveButtonSubject.onNext(())
        }).disposed(by: disposeBag)
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        contentView.addSubview(circularProgressView)
        circularProgressView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(30)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.height.equalTo(320)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalTo(circularProgressView.snp.center)
        }
        
        contentView.addSubview(changeGoalTextField)
        changeGoalTextField.snp.makeConstraints { make in
            make.top.equalTo(circularProgressView.snp.bottom).offset(54)
            make.left.equalTo(contentView.snp.left).inset(14)
            make.right.equalTo(contentView.snp.right).inset(14)
            make.height.equalTo(44)
        }
        
        contentView.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(changeGoalTextField.snp.bottom).offset(24)
            make.left.equalTo(contentView.snp.left).inset(14)
            make.right.equalTo(contentView.snp.right).inset(14)
            make.bottom.equalTo(contentView.snp.bottom).inset(14)
            make.height.equalTo(48)
        }
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = WalkViewModel.Input(date: dateSubject.asObservable(),
                                        goalStep: goalStepSubject.asObservable(),
                                        changeGoal: changeGoalSubject.asObservable(),
                                        save: saveButtonSubject.asObservable())
        let output = viewModel.transform(input: input)
        
        output.walkGoalSubject.drive(onNext: { [weak self] steps, goalSteps in
            guard let self = self else { return }
            self.stepLabel.text = steps.toString
            self.goalStepLabel.text = goalSteps.toString
            let progress = steps.toFloat / goalSteps.toFloat
            self.circularProgressView.setProgress(to: progress)
            self.changeGoalTextField.text = goalSteps.toString
        }).disposed(by: disposeBag)

        output.changeGoalStepSubject.drive(onNext: { [weak self] steps, changeGoalSteps in
            guard let self = self else { return }
            self.goalStepLabel.text = changeGoalSteps.toString
            let progress = steps.toFloat / changeGoalSteps.toFloat
            self.circularProgressView.setProgress(to: progress)
        }).disposed(by: disposeBag)
        
        output.saveSubject.drive(onNext: { [weak self] in
            guard let self = self else { return }
            self.router?.pop()
        }).disposed(by: disposeBag)
    }
}
