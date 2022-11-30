//
//  HomeViewModel.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 14/11/22.
//

import RxCocoa
import RxSwift

struct HomeViewModel: BaseViewModelType {
    
    private let disposeBag = DisposeBag()
    private let healthManager = HealthManager.shared
    
    private let navigationTitleSubject = BehaviorSubject<String>(value: "Home")
    private let walkSubject = PublishSubject<Int>()
    private let caloriesSubject = PublishSubject<Int>()
    private let heartRateSubject = PublishSubject<Int>()
    private let errorSubject = PublishSubject<String?>()
    private let sleepSubject = PublishSubject<String>()
    
    struct Input {
        var date: Observable<Date>
    }
    
    struct Output {
        var navigationTitleSubject: Driver<String>
        var walkSubject: Driver<Int>
        var caloriesSubject: Driver<Int>
        var heartRateSubject: Driver<Int>
        var errorSubject: Driver<String?>
        var sleepSubject: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        input.date.subscribe(onNext: { date in
            healthManager.getSteps(date: date).subscribe(onNext: { walkSubject.onNext($0) }).disposed(by: disposeBag)
            
            healthManager.getCalories(forSpecificDate: date) { calories in
                self.caloriesSubject.onNext(calories)
            }
            
            healthManager.getSleepHours(forSpecificDate: date) { hours in
                self.sleepSubject.onNext(hours.stringFromTimeInterval())
            }
            
            healthManager.getHeartRate(forSpecificDate: date) { state in
                switch state {
                case .success(let heartModel):
                    self.heartRateSubject.onNext(heartModel.value.toInt)
                case .failure(let error):
                    self.errorSubject.onNext(error)
                }
            }
        }).disposed(by: disposeBag)
        
        return Output(navigationTitleSubject: navigationTitleSubject.asDriver(onErrorJustReturn: ""),
                      walkSubject: walkSubject.asDriver(onErrorJustReturn: .zero),
                      caloriesSubject: caloriesSubject.asDriver(onErrorJustReturn: .zero),
                      heartRateSubject: heartRateSubject.asDriver(onErrorJustReturn: .zero),
                      errorSubject: errorSubject.asDriver(onErrorJustReturn: "Error"),
                      sleepSubject: sleepSubject.asDriver(onErrorJustReturn: "Error"))
    }
}
