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
    
    private let weeklySleepSubject = PublishSubject<[StatusProgressModel?]>()
    private let sleepSubject = PublishSubject<StatusProgressModel?>()
    private let todaySleepSubject = PublishSubject<String>()
    
    private let errorSubject = PublishSubject<String?>()
    
    struct Input {
        var heartRateDates: Observable<[Date]>
        var singleHeartRate: Observable<StatusProgressModel?>
        var previousHeartDates: Observable<[Date]>
        var sleepDates: Observable<[Date]>
        var singleSleep: Observable<StatusProgressModel?>
        var previousSleepDates: Observable<[Date]>
    }
    
    struct Output {
        var navigationTitleSubject: Driver<String>
        var todayHeartRateSubject: Driver<Int>
        var rateModelSubject: Driver<StatusProgressModel?>
        var weeklyHeartRateSubject: Driver<[StatusProgressModel?]>
        var todaySleepSubject: Driver<String>
        var sleepSubject: Driver<StatusProgressModel?>
        var weeklySleepSubject: Driver<[StatusProgressModel?]>
        var errorSubject: Driver<String?>
    }
    
    func transform(input: Input) -> Output {
        
        //MARK: Heart Dates
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
        
        healthManager.getHeartRate(forSpecificDate: Date()) { state in
            switch state {
            case .success(let heartModel):
                self.todayHeartRateSubject.onNext(heartModel.value.toInt)
            case .failure(let error):
                self.errorSubject.onNext(error)
            }
        }
        
        //MARK: Sleep Hours
        var hours = [StatusProgressModel?]()
        var previousHours = [Double]()
        input.sleepDates.subscribe(onNext: { dates in
            dates.forEach { date in
                healthManager.weeklySleepHours(forSpecificDate: date) { statusProgressModel in
                    let model = StatusProgressModel(value: statusProgressModel.value.hours, day: statusProgressModel.day)
                    sleepSubject.onNext(model)
                }
            }
        }).disposed(by: disposeBag)
        
        input.singleSleep.subscribe(onNext: { singleSleep in
            hours.append(singleSleep)
            self.weeklySleepSubject.onNext(hours)
        }).disposed(by: disposeBag)
        
        healthManager.getSleepHours(forSpecificDate: Date()) { hours in
            self.todaySleepSubject.onNext(hours.stringFromTimeInterval())
        }
        
        input.previousSleepDates.subscribe(onNext: { dates in
            dates.forEach { date in
                healthManager.weeklySleepHours(forSpecificDate: date) { statusProgressModel in
                    previousHours.append(statusProgressModel.value.hours)
                }
            }
        }).disposed(by: disposeBag)
        
        return Output(navigationTitleSubject: navigationTitleSubject.asDriver(onErrorJustReturn: ""),
                      todayHeartRateSubject: todayHeartRateSubject.asDriver(onErrorJustReturn: .zero),
                      rateModelSubject: rateModelSubject.asDriver(onErrorJustReturn: nil),
                      weeklyHeartRateSubject: weeklyHeartRateSubject.asDriver(onErrorJustReturn: []),
                      todaySleepSubject: todaySleepSubject.asDriver(onErrorJustReturn: "Error"),
                      sleepSubject: sleepSubject.asDriver(onErrorJustReturn: nil),
                      weeklySleepSubject: weeklySleepSubject.asDriver(onErrorJustReturn: []),
                      errorSubject: errorSubject.asDriver(onErrorJustReturn: "Error"))
    }
    
}
