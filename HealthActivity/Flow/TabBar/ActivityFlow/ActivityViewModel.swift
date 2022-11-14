//
//  ActivityViewModel.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 13/11/22.
//

import RxSwift
import RxCocoa

struct ActivityViewModel: BaseViewModelType {
    
    private let disposeBag = DisposeBag()
    private let healthManager = HealthTest.shared
    
    private let stepsSubject = PublishSubject<Int>()
    private let distanceSubject = PublishSubject<Double>()
    private let caloriesSubject = PublishSubject<Int>()
    private let pointsSubject = PublishSubject<Int>()
    
    struct Input {
        
    }
    
    struct Output {
        var stepsSubject: Driver<Int>
        var distanceSubject: Driver<Double>
        var caloriesSubject: Driver<Int>
        var pointsSubject: Driver<Int>
    }
    
    func transform(input: Input) -> Output {
        healthManager.getSteps { steps in
            self.stepsSubject.onNext(steps)
        }
        healthManager.getDistance { distance in
            self.distanceSubject.onNext(distance)
        }
        healthManager.getCalories { calories in
            self.caloriesSubject.onNext(calories)
        }
        healthManager.getActivePoints { points in
            self.pointsSubject.onNext(points)
        }
        
        return Output(stepsSubject: stepsSubject.asDriver(onErrorJustReturn: .zero),
                      distanceSubject: distanceSubject.asDriver(onErrorJustReturn: .zero),
                      caloriesSubject: caloriesSubject.asDriver(onErrorJustReturn: .zero),
                      pointsSubject: pointsSubject.asDriver(onErrorJustReturn: .zero))
    }
    
}
