//
//  ProfileViewModel.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 11/11/22.
//

import RxSwift
import RxCocoa

struct ProfileViewModel: BaseViewModelType {
    
    private let disposeBag = DisposeBag()
    private let healthManager = HealthManager.shared
    
    private let navigationTitleSubject = BehaviorSubject<String>(value: "Profile")
    private let walkSubject = PublishSubject<Int>()
    private let weightSubject = PublishSubject<Int>()
    private let heightSubject = PublishSubject<Int>()
    private let sleepSubject = PublishSubject<String>()
    private let caloriesSubject = PublishSubject<Int>()
    private let ageSubject = PublishSubject<String>()
    private let heartRateSubject = PublishSubject<Int>()
    
    struct Input {
        
    }
    
    struct Output {
        var navigationTitleSubject: Driver<String>
        var walkSubject: Driver<Int>
        var weightSubject: Driver<Int>
        var heightSubject: Driver<Int>
        var sleepSubject: Driver<String>
        var caloriesSubject: Driver<Int>
        var ageSubject: Driver<String>
        var heartRateSubject: Driver<Int>
    }
    
    func transform(input: Input) -> Output {
        healthManager.getSteps { steps in
            self.walkSubject.onNext(steps)
        }
        healthManager.getHeight(unit: .meter()) { height in
            self.heightSubject.onNext(height.toInt)
        }
        
        healthManager.getWeight(unit: .pound()) { weight in
            self.weightSubject.onNext(weight)
        }
        
        healthManager.getHeartRate { heartRate in
            self.heartRateSubject.onNext(heartRate.heartBPM)
        }
        
        healthManager.getCalories { calories in
            self.caloriesSubject.onNext(calories)
        }
        
        return Output(navigationTitleSubject: navigationTitleSubject.asDriver(onErrorJustReturn: ""),
                      walkSubject: walkSubject.asDriver(onErrorJustReturn: .zero),
                      weightSubject: weightSubject.asDriver(onErrorJustReturn: .zero),
                      heightSubject: heightSubject.asDriver(onErrorJustReturn: .zero),
                      sleepSubject: sleepSubject.asDriver(onErrorJustReturn: ""),
                      caloriesSubject: caloriesSubject.asDriver(onErrorJustReturn: .zero),
                      ageSubject: ageSubject.asDriver(onErrorJustReturn: "Not Set"),
                      heartRateSubject: heartRateSubject.asDriver(onErrorJustReturn: .zero))
    }
    
}
