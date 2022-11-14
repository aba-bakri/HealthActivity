//
//  ActivityViewController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 10/11/22.
//

import Foundation
import UIKit
import AYHorindar

class ActivityViewController: BaseController {
    
    private let horindarViewController = AYHorindarViewController()
    
    internal var router: ActivityRouter?
    internal var viewModel: ActivityViewModel!
    
    private lazy var calendarView: BaseView = {
        let view = BaseView(frame: .zero)
        view.setCornerRadius(corners: .allCorners, radius: 10)
        return view
    }()
    
    private lazy var activityView: ActivityView = {
        let view = ActivityView(frame: .zero)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "Your Activities"
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        let input = ActivityViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.stepsSubject.drive(onNext: { [weak self] steps in
            guard let self = self else { return }
            self.activityView.stepLabel.text = steps.toString
        }).disposed(by: disposeBag)
        
        output.distanceSubject.drive(onNext: { [weak self] distance in
            guard let self = self else { return }
            self.activityView.distanceValueLabel.text = "\(distance.rounded(toPlaces: 3).toString)"
        }).disposed(by: disposeBag)
        
        output.caloriesSubject.drive(onNext: { [weak self] calories in
            guard let self = self else { return }
            self.activityView.caloriesValueLabel.text = calories.toString
        }).disposed(by: disposeBag)
        
        output.pointsSubject.drive(onNext: { [weak self] calories in
            guard let self = self else { return }
            self.activityView.pointsValueLabel.text = calories.toString
        }).disposed(by: disposeBag)
    }
    
    override func setupControl() {
        super.setupControl()
        horindarViewController.delegate = self
        horindarViewController.dataSource = self
        horindarViewController.uiDelegate = self
        
        calendarView.addSubview(horindarViewController.view)
        calendarView.addAllSidesAnchors(to: horindarViewController.view)
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        
        contentView.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(14)
            make.left.equalTo(contentView.snp.left).inset(14)
            make.right.equalTo(contentView.snp.right).inset(14)
            make.height.equalTo(66)
        }
        
        contentView.addSubview(activityView)
        activityView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(30)
            make.left.equalTo(contentView.snp.left).inset(14)
            make.right.equalTo(contentView.snp.right).inset(14)
            make.bottom.equalTo(contentView.snp.bottom).inset(14)
        }
    }
    
}

extension ActivityViewController: AYHorindarDelegate, AYHorindarDataSource, AYHorindarUIDelegate {
    
    func current(date: Date) {
        print(date.log)
    }
    
    func locale() -> Locale {
        return Locale(identifier: "en_US_POSIX")
    }
    
    func selectedDate() -> Date {
        return Date()
    }
    
    func itemDisplayType() -> AYItemDisplayType {
        return .weekWithDay
    }
    
    func weekdayNameDisplayType() -> AYNameDisplayType {
        return .short
    }
    
}
