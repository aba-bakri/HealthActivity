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
    private let weightSubject = PublishSubject<(HKUnit, Int)>()
    private let heightSubject = PublishSubject<(HKUnit, Int)>()
    private let sleepSubject = PublishSubject<String>()
    private let caloriesSubject = PublishSubject<Int>()
    private let ageSubject = PublishSubject<String>()
    private let heartRateSubject = PublishSubject<Int>()
    private let errorSubject = PublishSubject<String?>()
    
    struct Input {
        
    }
    
    struct Output {
        var navigationTitleSubject: Driver<String>
        var walkSubject: Driver<Int>
        var weightSubject: Driver<(HKUnit, Int)>
        var heightSubject: Driver<(HKUnit, Int)>
        var sleepSubject: Driver<String>
        var caloriesSubject: Driver<Int>
        var ageSubject: Driver<String>
        var heartRateSubject: Driver<Int>
        var errorSubject: Driver<String?>
    }
    
    func transform(input: Input) -> Output {
        healthManager.getSteps { steps in
            self.walkSubject.onNext(steps)
        }
        healthManager.getHeight(unit: .meter()) { heightValue in
            let heightInt = (heightValue * 100).toInt
            let subject = (HKUnit.meter(), heightInt)
            self.heightSubject.onNext(subject)
        }
        
        healthManager.getWeight(unit: .pound()) { weight in
            let weightInt = (weight * 100).toInt
            let subject = (HKUnit.pound(), weightInt)
            self.weightSubject.onNext(subject)
        }
        
        healthManager.getHeartRate { state in
            switch state {
            case .success(let heartModel):
                self.heartRateSubject.onNext(heartModel.value.toInt)
            case .failure(let error):
                self.errorSubject.onNext(error)
            }
        }
        
        healthManager.getCalories { calories in
            self.caloriesSubject.onNext(calories)
        }
        
        healthManager.getSleepHours(forSpecificDate: Date()) { hours in
            self.sleepSubject.onNext(hours.stringFromTimeInterval())
        }
        
        return Output(navigationTitleSubject: navigationTitleSubject.asDriver(onErrorJustReturn: ""),
                      walkSubject: walkSubject.asDriver(onErrorJustReturn: .zero),
                      weightSubject: weightSubject.asDriver(onErrorJustReturn: (.pound(), .zero)),
                      heightSubject: heightSubject.asDriver(onErrorJustReturn: (.meter(), .zero)),
                      sleepSubject: sleepSubject.asDriver(onErrorJustReturn: ""),
                      caloriesSubject: caloriesSubject.asDriver(onErrorJustReturn: .zero),
                      ageSubject: ageSubject.asDriver(onErrorJustReturn: "Not Set"),
                      heartRateSubject: heartRateSubject.asDriver(onErrorJustReturn: .zero),
                      errorSubject: errorSubject.asDriver(onErrorJustReturn: "Error"))
    }
    
}
