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
    
    struct Input {
        
    }
    
    struct Output {
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
