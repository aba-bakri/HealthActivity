//
//  ProfileViewModel.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 11/11/22.
//

import RxSwift
import RxCocoa
import HealthKit

struct ProfileViewModel: BaseViewModelType {
    
    private let disposeBag = DisposeBag()
    private let healthManager = HealthManager.shared
    
    private let navigationTitleSubject = BehaviorSubject<String>(value: "Profile")
    private let walkSubject = PublishSubject<Int>()
    
    private let weightSubject = PublishSubject<(WeightUnit, Int)>()
    private let heightSubject = PublishSubject<(HeightUnit, Int)>()
    
    private let sleepSubject = PublishSubject<String>()
    private let caloriesSubject = PublishSubject<Int>()
    private let ageSubject = PublishSubject<String>()
    private let heartRateSubject = PublishSubject<Int>()
    private let errorSubject = PublishSubject<String?>()
    
    struct Input {
        var date: Observable<Date>
        var weightUnit: Observable<WeightUnit>
        var heightUnit: Observable<HeightUnit>
    }
    
    struct Output {
        var navigationTitleSubject: Driver<String>
        var walkSubject: Driver<Int>
        var weightSubject: Driver<(WeightUnit, Int)>
        var heightSubject: Driver<(HeightUnit, Int)>
        var sleepSubject: Driver<String>
        var caloriesSubject: Driver<Int>
        var ageSubject: Driver<String>
        var heartRateSubject: Driver<Int>
        var errorSubject: Driver<String?>
    }
    
    func transform(input: Input) -> Output {
        input.date.subscribe(onNext: { date in
            healthManager.getSteps(date: date).subscribe(onNext: { walkSubject.onNext($0) }).disposed(by: disposeBag)
            healthManager.getCalories(date: date).subscribe(onNext: { caloriesSubject.onNext($0) }).disposed(by: disposeBag)
            healthManager.getSleepHours(forSpecificDate: date) { hours in
                self.sleepSubject.onNext(hours.stringFromTimeInterval())
            }
        }).disposed(by: disposeBag)
        
        input.weightUnit.subscribe(onNext: { weightUnit in
            healthManager.getWeight(unit: weightUnit.unit) { weight in
                let subject = (weightUnit, weight.toInt)
                self.weightSubject.onNext(subject)
            }
        }).disposed(by: disposeBag)
        
        input.heightUnit.subscribe(onNext: { heightUnit in
            healthManager.getHeight(unit: heightUnit.unit).subscribe(onNext: { self.heightSubject.onNext((heightUnit, $0.toInt)) }).disposed(by: disposeBag)
        }).disposed(by: disposeBag)
        
        healthManager.getHeartRate { state in
            switch state {
            case .success(let heartModel):
                self.heartRateSubject.onNext(heartModel.value.toInt)
            case .failure(let error):
                self.errorSubject.onNext(error)
            }
        }
        
//        healthManager.getHeartRate().subscribe(onNext: { heartModel in
//            heartRateSubject.onNext(heartModel.value.toInt)
//        }).disposed(by: disposeBag)
        
        return Output(navigationTitleSubject: navigationTitleSubject.asDriver(onErrorJustReturn: ""),
                      walkSubject: walkSubject.asDriver(onErrorJustReturn: .zero),
                      weightSubject: weightSubject.asDriver(onErrorJustReturn: (.pound, .zero)),
                      heightSubject: heightSubject.asDriver(onErrorJustReturn: (.cm, .zero)),
                      sleepSubject: sleepSubject.asDriver(onErrorJustReturn: ""),
                      caloriesSubject: caloriesSubject.asDriver(onErrorJustReturn: .zero),
                      ageSubject: ageSubject.asDriver(onErrorJustReturn: "Not Set"),
                      heartRateSubject: heartRateSubject.asDriver(onErrorJustReturn: .zero),
                      errorSubject: errorSubject.asDriver(onErrorJustReturn: "Error"))
    }
    
}
