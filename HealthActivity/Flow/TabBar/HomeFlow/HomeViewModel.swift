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
    private let healthManager = HealthTest.shared
    
    private let walkSubject = PublishSubject<Int>()
    private let caloriesSubject = PublishSubject<Int>()
    
    struct Input {
        
    }
    
    struct Output {
        var walkSubject: Driver<Int>
        var caloriesSubject: Driver<Int>
    }
    
    func transform(input: Input) -> Output {
        
        healthManager.getSteps { steps in
            self.walkSubject.onNext(steps)
        }
        
        healthManager.getCalories { calories in
            self.caloriesSubject.onNext(calories)
        }
        
        return Output(walkSubject: walkSubject.asDriver(onErrorJustReturn: .zero),
                      caloriesSubject: caloriesSubject.asDriver(onErrorJustReturn: .zero))
    }
}
