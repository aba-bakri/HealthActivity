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
    
    struct Input {
        
    }
    
    struct Output {
        var navigationTitleSubject: Driver<String>
        var walkSubject: Driver<Int>
        var caloriesSubject: Driver<Int>
        var heartRateSubject: Driver<Int>
    }
    
    func transform(input: Input) -> Output {
        
        healthManager.getSteps { steps in
            self.walkSubject.onNext(steps)
        }
        
        healthManager.getCalories { calories in
            self.caloriesSubject.onNext(calories)
        }
        
        healthManager.getHeartRate { heartRate in
            if heartRate.heartBPM == .zero {
                self.heartRateSubject.onNext(.zero)
            } else {
                self.heartRateSubject.onNext(heartRate.heartBPM)
            }
        }
        
        return Output(navigationTitleSubject: navigationTitleSubject.asDriver(onErrorJustReturn: ""),
                      walkSubject: walkSubject.asDriver(onErrorJustReturn: .zero),
                      caloriesSubject: caloriesSubject.asDriver(onErrorJustReturn: .zero),
                      heartRateSubject: heartRateSubject.asDriver(onErrorJustReturn: .zero))
    }
}
