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
    private let healthManager = HealthManager.shared
    
    private let navigationTitleSubject = BehaviorSubject<String>(value: "Your Activities")
    private let stepsSubject = PublishSubject<Int>()
    private let distanceSubject = PublishSubject<Double>()
    private let caloriesSubject = PublishSubject<Int>()
    private let pointsSubject = PublishSubject<Int>()
    
    private let dateSubject = PublishSubject<Date>()
    
    struct Input {
        var date: Observable<Date>
    }
    
    struct Output {
        var navigationTitleSubject: Driver<String>
        var stepsSubject: Driver<Int>
        var distanceSubject: Driver<Double>
        var caloriesSubject: Driver<Int>
        var pointsSubject: Driver<Int>
    }
    
    func transform(input: Input) -> Output {
        input.date.subscribe(onNext: { date in
            healthManager.getSteps(date: date).subscribe(onNext: { stepsSubject.onNext($0) }).disposed(by: disposeBag)
            healthManager.getCalories(date: date).subscribe(onNext: { caloriesSubject.onNext($0) }).disposed(by: disposeBag)
            healthManager.getActivePoints(date: date).subscribe(onNext: { pointsSubject.onNext($0) }).disposed(by: disposeBag)
            healthManager.getDistance(date: date).subscribe(onNext: { distanceSubject.onNext($0) }).disposed(by: disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(navigationTitleSubject: navigationTitleSubject.asDriver(onErrorJustReturn: ""),
                      stepsSubject: stepsSubject.asDriver(onErrorJustReturn: .zero),
                      distanceSubject: distanceSubject.asDriver(onErrorJustReturn: .zero),
                      caloriesSubject: caloriesSubject.asDriver(onErrorJustReturn: .zero),
                      pointsSubject: pointsSubject.asDriver(onErrorJustReturn: .zero))
    }
    
}
