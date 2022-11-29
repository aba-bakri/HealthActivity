//
//  StatusViewController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 10/11/22.
//

import UIKit
import RxSwift
import RxCocoa

class StatusViewController: BaseController {
    
    private lazy var heartStatusView: StatusView = {
        let view = StatusView(type: .heart)
        return view
    }()
    
    private lazy var sleepStatusView: StatusView = {
        let view = StatusView(type: .sleep)
        return view
    }()
    
    private lazy var statusStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(heartStatusView)
        stackView.addArrangedSubview(sleepStatusView)
        return stackView
    }()
    
    internal var router: StatusRouter?
    internal var viewModel: StatusViewModel!
    
    private let heartRateDates = BehaviorSubject<[Date]>(value: Date().daysOfWeek())
    private let singleHeartRateSubject = PublishSubject<StatusProgressModel?>()
    private let previousHeartRateDates = BehaviorSubject<[Date]>(value: Date().previousWeek())
    private let previousHeartSubject = PublishSubject<Double>()
    
    private let sleepDates = BehaviorSubject<[Date]>(value: Date().daysOfWeek())
    private let singleSleepSubject = PublishSubject<StatusProgressModel?>()
    private let previousSleepDates = BehaviorSubject<[Date]>(value: Date().previousWeek())
    private let previousSleepSubject = PublishSubject<Double>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = StatusViewModel.Input(heartRateDates: heartRateDates.asObservable(),
                                          singleHeartRate: singleHeartRateSubject.asObservable(),
                                          previousHeartDates: previousHeartRateDates.asObservable(),
                                          previousSingleHeart: previousHeartSubject.asObservable(),
                                          sleepDates: sleepDates.asObservable(),
                                          singleSleep: singleSleepSubject.asObservable(),
                                          previousSleepDates: previousSleepDates.asObservable(),
                                          previousSingleSleep: previousSleepSubject.asObservable())
        let output = viewModel.transform(input: input)
        
        output.navigationTitleSubject.drive(onNext: { [weak self] title in
            guard let self = self else { return }
            self.navigationItem.title = title
        }).disposed(by: disposeBag)
        
        //MARK: Heart
        
        output.todayHeartRateSubject.drive(onNext: { [weak self] heartBPM in
            guard let self = self else { return }
            self.heartStatusView.configureTodayLabel(value: heartBPM.toString)
        }).disposed(by: disposeBag)

        output.rateModelSubject.drive(onNext: { [weak self] heartRate in
            guard let self = self else { return }
            self.singleHeartRateSubject.onNext(heartRate)
        }).disposed(by: disposeBag)
        
        output.weeklyHeartRateSubject.drive(onNext: { [weak self] weeklyHeartRates in
            guard let self = self else { return }
            self.heartStatusView.configureView(values: weeklyHeartRates)
        }).disposed(by: disposeBag)
        
        output.previousHeartSubject.drive(onNext: { [weak self] heart in
            guard let self = self else { return }
            self.previousHeartSubject.onNext(heart)
        }).disposed(by: disposeBag)
        
        output.previousHeartResultSubject.drive(onNext: { [weak self] previousHeartResult in
            guard let self = self else { return }
            self.heartStatusView.bottomMeasureValueLabel.text = previousHeartResult
        }).disposed(by: disposeBag)
        
        //MARK: Sleep
        
        output.todaySleepSubject.drive(onNext: { [weak self] hours in
            guard let self = self else { return }
            self.sleepStatusView.configureTodayLabel(value: hours)
        }).disposed(by: disposeBag)
        
        output.sleepSubject.drive(onNext: { [weak self] sleep in
            guard let self = self else { return }
            self.singleSleepSubject.onNext(sleep)
        }).disposed(by: disposeBag)
        
        output.weeklySleepSubject.drive(onNext: { [weak self] weeklySleep in
            guard let self = self else { return }
            self.sleepStatusView.configureView(values: weeklySleep)
        }).disposed(by: disposeBag)
        
        output.previousSleepSubject.drive(onNext: { [weak self] sleep in
            guard let self = self else { return }
            self.previousSleepSubject.onNext(sleep)
        }).disposed(by: disposeBag)
        
        output.previousSleepResultSubject.drive(onNext: { [weak self] previousSleepResult in
            guard let self = self else { return }
            self.sleepStatusView.bottomMeasureValueLabel.text = previousSleepResult
        }).disposed(by: disposeBag)
        
        output.errorSubject.drive(onNext: { [weak self] error in
            guard let self = self else { return }
            self.heartStatusView.emptyLabel.text = error
        }).disposed(by: disposeBag)
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        contentView.addSubview(statusStackView)
        statusStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges).inset(14)
        }
        
        [heartStatusView, sleepStatusView].forEach { statusView in
            statusView.snp.makeConstraints { make in
                make.height.equalTo(350)
            }
        }
    }
    
}
