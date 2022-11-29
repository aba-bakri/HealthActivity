//
//  PersonalInfoViewModel.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 11/11/22.
//

import RxSwift
import RxCocoa
import HealthKit

struct UpdateHeight {
    var heightUnit: HeightUnit
    var height: Double
}

struct UpdateWeight {
    var weightUnit: WeightUnit
    var weight: Double
}

struct PersonalInfoViewModel: BaseViewModelType {
    
    private let disposeBag = DisposeBag()
    private let healthManager = HealthManager.shared
    
    private let navigationTitleSubject = BehaviorSubject<String>(value: "Personal Info")
    private let heightSubject = PublishSubject<(HeightUnit, Int)>()
    private let weightSubject = PublishSubject<(WeightUnit, Int)>()
    private let changeHeightSubject = PublishSubject<Int>()
    private let changeWeightSubject = PublishSubject<Int>()
    private let errorSubject = PublishSubject<String?>()
    
    private let saveHeightSubject = PublishSubject<UpdateHeight?>()
    private let saveWeightSubject = PublishSubject<UpdateWeight?>()
    
    struct Input {
        var heightUnit: Observable<HeightUnit>
        var weightUnit: Observable<WeightUnit>
        var changeHeight: Observable<Int>
        var changeWeight: Observable<Int>
        var saveHeight: Observable<Void>
        var saveWeight: Observable<Void>
    }
    
    struct Output {
        var navigationTitle: Driver<String>
        var heightSubjet: Driver<(HeightUnit, Int)>
        var weightSubject: Driver<(WeightUnit, Int)>
        var changeHeightSubject: Driver<Int>
        var changeWeightSubject: Driver<Int>
        var errorSubject: Driver<String?>
        var saveHeight: Driver<UpdateHeight?>
        var saveWeight: Driver<UpdateWeight?>
    }
    
    func transform(input: Input) -> Output {
        var tempHeightValue: Int = .zero
        var tempWeightValue: Int = .zero
        
        input.heightUnit.subscribe(onNext: { heightUnit in
            self.healthManager.getHeight(unit: heightUnit.unit) { heightValue in
                let height = heightUnit == .cm ? (heightValue * 100).toInt : heightValue.toInt
                let subject = (heightUnit, height)
                self.heightSubject.onNext(subject)
            }
        }).disposed(by: disposeBag)
        
        input.weightUnit.subscribe(onNext: { weightUnit in
            self.healthManager.getWeight(unit: weightUnit.unit) { weightValue in
                let subject = (weightUnit, weightValue.toInt)
                self.weightSubject.onNext(subject)
            }
        }).disposed(by: disposeBag)
        
        input.changeHeight.subscribe(onNext: { heightValue in
            tempHeightValue = heightValue
        }).disposed(by: disposeBag)
        
        input.changeWeight.subscribe(onNext: { weightValue in
            tempWeightValue = weightValue
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(input.heightUnit, input.saveHeight).subscribe(onNext: { heightUnit, _  in
            let heightDouble = heightUnit == .cm ? Double(Double(tempHeightValue) / 100) : Double(tempHeightValue)
            healthManager.changeHeight(unit: heightUnit.unit, height: heightDouble) { state in
                switch state {
                case .success:
                    let model = UpdateHeight(heightUnit: heightUnit, height: heightDouble)
                    self.saveHeightSubject.onNext(model)
                case .failure(let error):
                    self.errorSubject.onNext(error)
                }
            }
        }).disposed(by: disposeBag)

        Observable.combineLatest(input.weightUnit, input.saveWeight).subscribe(onNext: { weightUnit, _ in
            let weightDouble = Double(tempWeightValue)
            healthManager.changeWeight(unit: weightUnit.unit, weight: weightDouble) { state in
                switch state {
                case .success:
                    let model = UpdateWeight(weightUnit: weightUnit, weight: weightDouble)
                    self.saveWeightSubject.onNext(model)
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
                      saveHeight: saveHeightSubject.asDriver(onErrorJustReturn: nil),
                      saveWeight: saveWeightSubject.asDriver(onErrorJustReturn: nil))
    }
}
