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
    private let saveButtonSubject = PublishSubject<()>()
    private let heightSubject = PublishSubject<(HeightUnit, Int)>()
    private let weightSubject = PublishSubject<(WeightUnit, Int)>()
    private let changeHeightSubject = PublishSubject<Int>()
    private let changeWeightSubject = PublishSubject<Int>()
    private let errorSubject = PublishSubject<String?>()
    
    struct Input {
        var saveButton: Observable<Void>
        var heightUnit: Observable<HeightUnit>
        var weightUnit: Observable<WeightUnit>
        var changeHeight: Observable<Int>
        var changeWeight: Observable<Int>
    }
    
    struct Output {
        var navigationTitle: Driver<String>
        var heightSubjet: Driver<(HeightUnit, Int)>
        var weightSubject: Driver<(WeightUnit, Int)>
        var changeHeightSubject: Driver<Int>
        var changeWeightSubject: Driver<Int>
        var errorSubject: Driver<String?>
        var saveSubject: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        var tempHeightUnit: HeightUnit = .cm
        var tempHeightValue: Int = .zero
        
        var tempWeightUnit: WeightUnit = .pound
        var tempWeightValue: Int = .zero
        
        input.heightUnit.subscribe(onNext: { heightUnit in
            tempHeightUnit = heightUnit
            self.healthManager.getHeight(unit: heightUnit.unit) { heightValue in
                let cm = (heightValue * 100).toInt
                let subject = (heightUnit, cm)
                self.heightSubject.onNext(subject)
            }
        }).disposed(by: disposeBag)
        
        input.weightUnit.subscribe(onNext: { weightUnit in
            tempWeightUnit = tempWeightUnit
            self.healthManager.getWeight(unit: weightUnit.unit) { weightValue in
                let pound = (weightValue * 100).toInt
                let subject = (weightUnit, pound)
                self.weightSubject.onNext(subject)
            }
        }).disposed(by: disposeBag)
        
        input.changeHeight.subscribe(onNext: { heightValue in
            tempHeightValue = heightValue
        }).disposed(by: disposeBag)
        
        input.changeWeight.subscribe(onNext: { weightValue in
            tempWeightValue = weightValue
        }).disposed(by: disposeBag)
        
        input.saveButton.subscribe(onNext: { _ in
            let heightDouble = Double(Double(tempHeightValue) / 100)
            healthManager.changeHeight(unit: tempHeightUnit.unit, height: heightDouble) { state in
                switch state {
                case .success:
                    let weightDouble = Double(Double(tempWeightValue) / 100)
                    healthManager.changeWeight(unit: tempWeightUnit.unit, weight: weightDouble) { state in
                        switch state {
                        case .success:
                            self.saveButtonSubject.onNext(())
                        case .failure(let error):
                            self.errorSubject.onNext(error)
                        }
                    }
                case .failure(let error):
                    self.errorSubject.onNext(error)
                }
            }
        }).disposed(by: disposeBag)
        
        return Output(navigationTitle: navigationTitleSubject.asDriver(onErrorJustReturn: ""),
                      heightSubjet: heightSubject.asDriver(onErrorJustReturn: (.cm, .zero)),
                      weightSubject: weightSubject.asDriver(onErrorJustReturn: (.pound, .zero)),
                      changeHeightSubject: changeHeightSubject.asDriver(onErrorJustReturn: .zero),
                      changeWeightSubject: changeWeightSubject.asDriver(onErrorJustReturn: .zero),
                      errorSubject: errorSubject.asDriver(onErrorJustReturn: "Error"),
                      saveSubject: saveButtonSubject.asDriver(onErrorJustReturn: ()))
    }
}
