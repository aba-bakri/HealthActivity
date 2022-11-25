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
    
    private let sleepDates = BehaviorSubject<[Date]>(value: Date().daysOfWeek())
    private let singleSleepSubject = PublishSubject<StatusProgressModel?>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupControl() {
        super.setupControl()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = StatusViewModel.Input(heartRateDates: heartRateDates.asObservable(),
                                          singleHeartRate: singleHeartRateSubject.asObservable(),
                                          sleepDates: sleepDates.asObservable(),
                                          singleSleep: singleSleepSubject.asObservable())
        let output = viewModel.transform(input: input)
        
        output.navigationTitleSubject.drive(onNext: { [weak self] title in
            guard let self = self else { return }
            self.navigationItem.title = title
        }).disposed(by: disposeBag)
        
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
            self.heartStatusView.configureView(rates: weeklyHeartRates)
        }).disposed(by: disposeBag)
        
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
            self.sleepStatusView.configureView(rates: weeklySleep)
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
                make.height.equalTo(330)
            }
        }
    }
    
}
