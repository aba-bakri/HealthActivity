//
//  HomeViewController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: BaseController {
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = R.color.blackLabel()
        label.text = "Welcome, Back!"
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = R.color.grayLabel()
        label.text = "Hi, \(UserDefaultStorage.firstName ?? "")"
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
    
    private lazy var heartView: InfoView = {
        let view = InfoView(type: .heart)
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
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 14
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(heartView)
        stackView.addArrangedSubview(caloriesView)
        return stackView
    }()
    
    internal var router: HomeRouter?
    internal var viewModel: HomeViewModel!
    
    private let dateSubject = BehaviorSubject<Date>(value: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindViewModel()
    }

    override func setupControl() {
        super.setupControl()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = HomeViewModel.Input(date: dateSubject.asObservable())
        let output = viewModel.transform(input: input)
        
        output.navigationTitleSubject.drive(onNext: { [weak self] title in
            guard let self = self else { return }
            self.navigationItem.title = title
        }).disposed(by: disposeBag)
        
        output.walkSubject.drive(onNext: { [weak self] steps in
            guard let self = self else { return }
            self.walkView.valueLabel.text = steps.toString
            self.walkView.circularView.setProgress(to: steps.toFloat / UserDefaultStorage.stepGoal.toFloat)
        }).disposed(by: disposeBag)
        
        output.heartRateSubject.drive(onNext: { [weak self] bpm in
            guard let self = self else { return }
            self.heartView.configureValueLabel(value: bpm)
        }).disposed(by: disposeBag)
        
        output.errorSubject.drive(onNext: { [weak self] error in
            guard let self = self else { return }
            self.heartView.configureError(value: error)
        }).disposed(by: disposeBag)
        
        output.caloriesSubject.drive(onNext: { [weak self] calories in
            guard let self = self else { return }
            self.caloriesView.valueLabel.text = calories.toString
        }).disposed(by: disposeBag)
        
        output.sleepSubject.drive(onNext: { [weak self] hours in
            guard let self = self else { return }
            self.sleepView.valueLabel.text = hours
        }).disposed(by: disposeBag)
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
        }
        
        [heartView, caloriesView].forEach { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(145)
            }
        }
        
        contentView.addSubview(walkView)
        walkView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(14)
            make.left.equalTo(contentView.snp.left).inset(14)
            make.bottom.greaterThanOrEqualTo(contentView.snp.bottom).inset(14)
            make.height.equalTo(244)
        }
        
        contentView.addSubview(sleepView)
        sleepView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(14)
            make.left.equalTo(walkView.snp.right).offset(14)
            make.right.equalTo(contentView.snp.right).inset(14)
            make.width.equalTo(heartView.snp.width)
            make.height.equalTo(145)
        }
    }

}
