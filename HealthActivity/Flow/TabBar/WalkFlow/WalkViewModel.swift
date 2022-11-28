//
//  WalkViewModel.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 26/11/22.
//

import RxCocoa
import RxSwift

struct WalkViewModel: BaseViewModelType {
    
    private let disposeBag = DisposeBag()
    private let healthManager = HealthManager.shared
    
    private let walkGoalSubject = PublishSubject<(Int, Int)>()
    private let goalSubject = PublishSubject<Int>()
    private let changeGoalSubject = PublishSubject<(Int, Int)>()
    private let saveSubject = PublishSubject<()>()
    
    struct Input {
        var date: Observable<Date>
        var goalStep: Observable<Int>
        var changeGoal: Observable<Int>
        var save: Observable<Void>
    }
    
    struct Output {
        var walkGoalSubject: Driver<(Int, Int)>
        var changeGoalStepSubject: Driver<(Int, Int)>
        var saveSubject: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        var tempSteps: Int = .zero
        var tempChangeSteps: Int = .zero
        input.date.subscribe(onNext: { date in
            healthManager.getSteps(forSpecificDate: date) { steps in
                tempSteps = steps
                input.goalStep.subscribe(onNext: { goalSteps in
                    self.walkGoalSubject.onNext((steps, goalSteps))
                }).disposed(by: disposeBag)
            }
        }).disposed(by: disposeBag)
        
        input.changeGoal.subscribe(onNext: { changeSteps in
            tempChangeSteps = changeSteps
            changeGoalSubject.onNext((tempSteps, changeSteps))
        }).disposed(by: disposeBag)
        
        input.save.subscribe(onNext: { _ in
            UserDefaultStorage.stepGoal = tempChangeSteps
            self.saveSubject.onNext(())
        }).disposed(by: disposeBag)
        
        return Output(walkGoalSubject: walkGoalSubject.asDriver(onErrorJustReturn: (.zero, .zero)),
                      changeGoalStepSubject: changeGoalSubject.asDriver(onErrorJustReturn: (.zero, .zero)),
                      saveSubject: saveSubject.asDriver(onErrorJustReturn: ()))
    }
}
