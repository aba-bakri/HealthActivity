//
//  PersonalInfoViewModel.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 11/11/22.
//

import RxSwift
import RxCocoa
import HealthKit

struct PersonalInfoViewModel: BaseViewModelType {
    
    private let disposeBag = DisposeBag()
    private let healthManager = HealthManager.shared
    
    private let navigationTitleSubject = BehaviorSubject<String>(value: "Personal Info")
    private let nextButtonSubject = PublishSubject<Bool>()
    private let heightSubject = PublishSubject<(HKUnit, Int)>()
    private let weightSubject = PublishSubject<(HKUnit, Int)>()
    private let changeHeightSubject = PublishSubject<Int>()
    private let changeWeightSubject = PublishSubject<Int>()
    private let errorSubject = PublishSubject<String?>()
    
    struct Input {
        var nextButton: Observable<Bool>
        var heightUnit: Observable<HKUnit>
        var weightUnit: Observable<HKUnit>
        var changeHeight: Observable<Int>
        var changeWeight: Observable<Int>
    }
    
    struct Output {
        var navigationTitle: Driver<String>
        var nextButtonSubject: Driver<Bool>
        var heightSubjet: Driver<(HKUnit, Int)>
        var weightSubject: Driver<(HKUnit, Int)>
        var changeHeightSubject: Driver<Int>
        var changeWeightSubject: Driver<Int>
        var errorSubject: Driver<String?>
    }
    
    func transform(input: Input) -> Output {
        input.heightUnit.subscribe(onNext: { heightUnit in
            self.healthManager.getHeight(unit: heightUnit) { heightValue in
                let cm = (heightValue * 100).toInt
                let subject = (heightUnit, cm)
                self.heightSubject.onNext(subject)
            }
        }).disposed(by: disposeBag)
        
        input.weightUnit.subscribe(onNext: { weightUnit in
            self.healthManager.getWeight(unit: weightUnit) { weightValue in
                let pound = (weightValue * 100).toInt
                let subject = (weightUnit, pound)
                self.weightSubject.onNext(subject)
            }
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(input.nextButton, input.changeHeight).subscribe(onNext: { isButtonEnabled, heightValue in
            if isButtonEnabled {
                self.changeHeightSubject.onNext(heightValue)
                let heightDouble = Double(Double(heightValue) / 100)
                healthManager.changeHeight(unit: .meter(), height: heightDouble) { state in
                    switch state {
                    case .success:
                        self.nextButtonSubject.onNext(true)
                    case .failure(let error):
                        self.errorSubject.onNext(error)
                    }
                }
            } else {
                self.nextButtonSubject.onNext(false)
            }
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(input.nextButton, input.changeWeight).subscribe(onNext: { isButtonEnabled, weightValue in
            if isButtonEnabled {
                self.changeWeightSubject.onNext(weightValue)
                let weightDouble = Double(Double(weightValue) / 100)
                healthManager.changeWeight(unit: .pound(), weight: weightDouble) { state in
                    switch state {
                    case .success:
                        self.nextButtonSubject.onNext(true)
                    case .failure(let error):
                        self.errorSubject.onNext(error)
                    }
                }
            } else {
                self.nextButtonSubject.onNext(false)
            }
        }).disposed(by: disposeBag)
        
        return Output(navigationTitle: navigationTitleSubject.asDriver(onErrorJustReturn: ""),
                      nextButtonSubject: nextButtonSubject.asDriver(onErrorJustReturn: false),
                      heightSubjet: heightSubject.asDriver(onErrorJustReturn: (.meter(), .zero)),
                      weightSubject: weightSubject.asDriver(onErrorJustReturn: (.pound(), .zero)),
                      changeHeightSubject: changeHeightSubject.asDriver(onErrorJustReturn: .zero),
                      changeWeightSubject: changeWeightSubject.asDriver(onErrorJustReturn: .zero),
                      errorSubject: errorSubject.asDriver(onErrorJustReturn: "Error"))
    }
}
