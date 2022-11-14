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
    private let healthManager = HealthTest.shared
    
    private let walkSubject = PublishSubject<Int>()
    private let weightSubject = PublishSubject<Int>()
    private let heightSubject = PublishSubject<Int>()
    private let sleepSubject = PublishSubject<String>()
    private let caloriesSubject = PublishSubject<Int>()
    private let ageSubject = PublishSubject<String>()
    
    struct Input {
        
    }
    
    struct Output {
        var walkSubject: Driver<Int>
        var weightSubject: Driver<Int>
        var heightSubject: Driver<Int>
        var sleepSubject: Driver<String>
        var caloriesSubject: Driver<Int>
        var ageSubject: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        healthManager.getSteps { steps in
            self.walkSubject.onNext(steps)
        }
        
        healthManager.getWeight { weight in
            self.weightSubject.onNext(weight)
        }
        
        healthManager.getHeight { height in
            self.heightSubject.onNext(height)
        }
        
//        healthManager.getSleepHours() { done in
//            self.sleepSubject.onNext(done.toString)
//        }
        
        healthManager.getCalories { calories in
            self.caloriesSubject.onNext(calories)
        }
        
//        healthManager.getAge { age in
//            self.ageSubject.onNext(healthManager.getAge())
//        }
        
        return Output(walkSubject: walkSubject.asDriver(onErrorJustReturn: .zero),
                      weightSubject: weightSubject.asDriver(onErrorJustReturn: .zero),
                      heightSubject: heightSubject.asDriver(onErrorJustReturn: .zero),
                      sleepSubject: sleepSubject.asDriver(onErrorJustReturn: ""),
                      caloriesSubject: caloriesSubject.asDriver(onErrorJustReturn: .zero),
                      ageSubject: ageSubject.asDriver(onErrorJustReturn: "Not Set"))
    }
    
}
