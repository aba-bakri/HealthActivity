//
//  ActivityViewController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 10/11/22.
//

import Foundation
import UIKit
import RxSwift

class ActivityViewController: BaseController {
    
    internal var router: ActivityRouter?
    internal var viewModel: ActivityViewModel!
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker(frame: .zero)
        picker.tintColor = UIColor(named: "purple")
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        if #available(iOS 14.0, *) {
            picker.preferredDatePickerStyle = .inline
        } else {
            picker.preferredDatePickerStyle = .automatic
        }
        picker.addTarget(self, action: #selector(datePickerAction), for: .valueChanged)
        return picker
    }()
    
    private lazy var activityView: ActivityView = {
        let view = ActivityView(frame: .zero)
        return view
    }()
    
    private let dateSubject = BehaviorSubject<Date>(value: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindUI() {
        super.bindUI()
        datePicker.rx.date.bind(to: dateSubject).disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        let input = ActivityViewModel.Input(date: dateSubject)
        let output = viewModel.transform(input: input)
        
        output.navigationTitleSubject.drive(onNext: { [weak self] title in
            guard let self = self else { return }
            self.navigationItem.title = title
        }).disposed(by: disposeBag)
        
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
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        contentView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left).inset(14)
        }
        
        contentView.addSubview(activityView)
        activityView.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(14)
            make.left.equalTo(contentView.snp.left).inset(14)
            make.right.equalTo(contentView.snp.right).inset(14)
            make.bottom.equalTo(contentView.snp.bottom).inset(14)
            make.height.equalTo(250)
        }
    }
    
    @objc private func datePickerAction() {
        
    }
    
}
