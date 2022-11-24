//
//  OnboardingViewModel.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 19/11/22.
//

import RxSwift
import RxCocoa

enum OnboardingItem: CaseIterable {
    case first
    case second
    case third
    
    var backgroundImage: UIImage? {
        switch self {
        case .first:
            return R.image.onboardingFirst()
        case .second:
            return R.image.onboardingSecond()
        case .third:
            return R.image.onboardingThird()
        }
    }
    
    var title: String? {
        switch self {
        case .first:
            return "Don’t stand still".uppercased()
        case .second:
            return "Set Goals".uppercased()
        case .third:
            return "Start training".uppercased()
        }
    }
    
    var subtitle: String? {
        switch self {
        case .first:
            return "Join the community of runners and take training seriously and for a long time"
        case .second:
            return "...And track your sports achievements"
        case .third:
            return "Choose your own exercise mode and get to your goal even faster"
        }
    }
}

struct OnboardingViewModel: BaseViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
    }
    
    func transform(input: Input) -> Output {
        Output()
    }
    
}
