//
//  StatusViewModel.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 17/11/22.
//

import RxSwift
import RxCocoa

struct StatusViewModel: BaseViewModelType {
    
    private let disposeBag = DisposeBag()
    private let healthManager = HealthManager.shared
    
    private let navigationTitleSubject = BehaviorSubject<String>(value: "Status For Week")
    private let weeklyHeartRateSubject = PublishSubject<[StatusProgressModel?]>()
    private let rateModelSubject = PublishSubject<StatusProgressModel?>()
    private let todayHeartRateSubject = PublishSubject<Int>()
    
    struct Input {
        var heartRateDates: Observable<[Date]>
        var singleHeartRate: Observable<StatusProgressModel?>
    }
    
    struct Output {
        var navigationTitleSubject: Driver<String>
        var todayHeartRateSubject: Driver<Int>
        var rateModelSubject: Driver<StatusProgressModel?>
        var weeklyHeartRateSubject: Driver<[StatusProgressModel?]>
    }
    
    func transform(input: Input) -> Output {
        var heartRates = [StatusProgressModel?]()
        input.heartRateDates.subscribe(onNext: { dates in
            dates.forEach { date in
                healthManager.getWeeklyHeartRate(forSpecificDate: date) { statusProgressModel in
                    rateModelSubject.onNext(statusProgressModel)
                }
            }
        }).disposed(by: disposeBag)
        
        input.singleHeartRate.subscribe(onNext: { singleHeartRate in
            heartRates.append(singleHeartRate)
            self.weeklyHeartRateSubject.onNext(heartRates)
        }).disposed(by: disposeBag)
        
        healthManager.getHeartRate(forSpecificDate: Date()) { heartRateModel in
            self.todayHeartRateSubject.onNext(heartRateModel.heartBPM)
        }
        
        return Output(navigationTitleSubject: navigationTitleSubject.asDriver(onErrorJustReturn: ""),
                      todayHeartRateSubject: todayHeartRateSubject.asDriver(onErrorJustReturn: .zero),
                      rateModelSubject: rateModelSubject.asDriver(onErrorJustReturn: nil),
                      weeklyHeartRateSubject: weeklyHeartRateSubject.asDriver(onErrorJustReturn: []))
    }
    
}
