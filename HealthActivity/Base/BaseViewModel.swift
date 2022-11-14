//
//  BaseViewModel.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 11/11/22.
//

protocol BaseViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
