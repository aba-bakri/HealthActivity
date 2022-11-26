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
    private let previousHeartSubject = PublishSubject<Double>()
    private let previousHeartResultSubject = PublishSubject<String>()
    
    private let weeklySleepSubject = PublishSubject<[StatusProgressModel?]>()
    private let sleepSubject = PublishSubject<StatusProgressModel?>()
    private let todaySleepSubject = PublishSubject<String>()
    private let previousSleepSubject = PublishSubject<Double>()
    private let previousSleepResultSubject = PublishSubject<String>()
    
    private let errorSubject = PublishSubject<String?>()
    
    struct Input {
        var heartRateDates: Observable<[Date]>
        var singleHeartRate: Observable<StatusProgressModel?>
        var previousHeartDates: Observable<[Date]>
        var previousSingleHeart: Observable<Double>
        
        var sleepDates: Observable<[Date]>
        var singleSleep: Observable<StatusProgressModel?>
        var previousSleepDates: Observable<[Date]>
        var previousSingleSleep: Observable<Double>
    }
    
    struct Output {
        var navigationTitleSubject: Driver<String>
        
        var todayHeartRateSubject: Driver<Int>
        var rateModelSubject: Driver<StatusProgressModel?>
        var weeklyHeartRateSubject: Driver<[StatusProgressModel?]>
        var previousHeartSubject: Driver<Double>
        var previousHeartResultSubject: Driver<String>
        
        var todaySleepSubject: Driver<String>
        var sleepSubject: Driver<StatusProgressModel?>
        var weeklySleepSubject: Driver<[StatusProgressModel?]>
        var previousSleepSubject: Driver<Double>
        var previousSleepResultSubject: Driver<String>
        
        var errorSubject: Driver<String?>
    }
    
    func transform(input: Input) -> Output {
        
        //MARK: Heart Dates
        var heartRates = [StatusProgressModel?]()
        var previousHeartRates = [Double]()
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
        
        input.previousHeartDates.subscribe(onNext: { dates in
            dates.forEach { date in
                healthManager.getWeeklyHeartRate(forSpecificDate: date) { statusProgressModel in
                    previousHeartSubject.onNext(statusProgressModel.value)
                }
            }
        }).disposed(by: disposeBag)
        
        input.previousSingleHeart.subscribe(onNext: { hours in
            previousHeartRates.append(hours)
            let result = "\(previousHeartRates.min()?.toInt ?? .zero)-\(previousHeartRates.max()?.toInt ?? .zero)"
            self.previousHeartResultSubject.onNext(result)
        }).disposed(by: disposeBag)
        
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
                    previousSleepSubject.onNext(statusProgressModel.value.hours)
                }
            }
        }).disposed(by: disposeBag)
        
        input.previousSingleSleep.subscribe(onNext: { hours in
            previousHours.append(hours)
            let result = "\(previousHours.min()?.toInt ?? .zero)-\(previousHours.max()?.toInt ?? .zero)"
            self.previousSleepResultSubject.onNext(result)
        }).disposed(by: disposeBag)
        
        return Output(navigationTitleSubject: navigationTitleSubject.asDriver(onErrorJustReturn: ""),
                      todayHeartRateSubject: todayHeartRateSubject.asDriver(onErrorJustReturn: .zero),
                      rateModelSubject: rateModelSubject.asDriver(onErrorJustReturn: nil),
                      weeklyHeartRateSubject: weeklyHeartRateSubject.asDriver(onErrorJustReturn: []),
                      previousHeartSubject: previousHeartSubject.asDriver(onErrorJustReturn: .zero),
                      previousHeartResultSubject: previousHeartResultSubject.asDriver(onErrorJustReturn: "0"),
                      todaySleepSubject: todaySleepSubject.asDriver(onErrorJustReturn: "Error"),
                      sleepSubject: sleepSubject.asDriver(onErrorJustReturn: nil),
                      weeklySleepSubject: weeklySleepSubject.asDriver(onErrorJustReturn: []),
                      previousSleepSubject: previousSleepSubject.asDriver(onErrorJustReturn: .zero),
                      previousSleepResultSubject: previousSleepResultSubject.asDriver(onErrorJustReturn: "0"),
                      errorSubject: errorSubject.asDriver(onErrorJustReturn: "Error"))
    }
    
}
