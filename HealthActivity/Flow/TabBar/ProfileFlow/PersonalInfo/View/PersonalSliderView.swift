//
//  PersonalSliderView.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit
import HealthKit
import DTRuler

class PersonalSliderView: BaseView {
    
    public var rulerValueDidChange: ((String) -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(named: "blackLabel")
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = unitType.title
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(named: "grayLabel")
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)
        return stackView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [unitType.unitLabels.0, unitType.unitLabels.1])
        control.selectedSegmentTintColor = UIColor.white
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "segmentedGray") ?? .lightGray], for: .normal)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "purple") ?? .purple], for: .selected)
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return control
    }()
    
//    lazy var pickerView: UIPickerView = {
//        let pickerView = UIPickerView(frame: .zero)
//        pickerView.delegate = self
//        pickerView.dataSource = self
//        pickerView.tintColor = UIColor(named: "purple")
//        pickerView.selectRow(0, inComponent: 0, animated: true)
//        return pickerView
//    }()
    
    private var unitType: HeightWeightType
    
    private var unitData = [Int]()
    private let pickerDataSize = 100_000
    
    private lazy var rulerView: DTRuler = {
        let ruler = DTRuler(scale: .integer(0), minScale: .integer(30), maxScale: .integer(unitType.unitLimit.0), width: bounds.width - 50)
        ruler.delegate = self
        ruler.translatesAutoresizingMaskIntoConstraints = false
        ruler.setCornerRadius(corners: .allCorners, radius: 10)
        return ruler
    }()
    
    public init(type: HeightWeightType) {
        self.unitType = type
        super.init(frame: .zero)
        setupControl()
        setupComponentsUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not .been implemented")
    }
    
    override func setupControl() {
        super.setupControl()
        DTRuler.theme = Colorful()
//        unitData = [Int](1...unitType.unitLimit.0)
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        addSubview(labelStackView)
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(14)
            make.left.equalTo(snp.left).inset(20)
        }
        
        addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.centerY.equalTo(labelStackView.snp.centerY)
            make.right.equalTo(snp.right).inset(20)
        }
        
        addSubview(rulerView)
        rulerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(14)
            make.left.equalTo(snp.left).inset(25)
            make.right.equalTo(snp.right).inset(25)
            make.bottom.equalTo(snp.bottom)
            make.height.equalTo(115)
        }
        
        //        addSubview(pickerView)
        //        pickerView.snp.makeConstraints { make in
//                    make.top.equalTo(labelStackView.snp.bottom).offset(14)
//                    make.left.equalTo(snp.left)
//                    make.right.equalTo(snp.right)
//                    make.bottom.equalTo(snp.bottom)
        //        }
    }
    
    @objc private func segmentedControlValueChanged() {
        //        if segmentedControl.selectedSegmentIndex == 0 {
        //            unitData = [Int](1...unitType.unitLimit.0)
        //        } else {
        //            unitData = [Int](1...unitType.unitLimit.1)
        //        }
        //        pickerView.reloadAllComponents()
        if segmentedControl.selectedSegmentIndex == 0 {
            rulerViewDataSource(scale: .integer(150), unitLimit: unitType.unitLimit.0)
        } else {
            rulerViewDataSource(scale: .integer(150), unitLimit: unitType.unitLimit.1)
        }
    }
    
    func selectValueRow(row: Int) {
//        pickerView.selectRow(row, inComponent: 0, animated: true)
//        rulerView.
    }
    
    //    func convertLbToKg(lb: Int) -> Measurement<UnitMass> {
    //        let unitKg = UnitMass.kilograms
    //        let measurement: Measurement = Measurement(value: Double(lb), unit: unitKg)
    //        return measurement.converted(to: .pounds)
    //    }
    
    func selectUnitControl(unit: HKUnit) {
        switch unit {
        case .meter(), .pound():
            segmentedControl.selectedSegmentIndex = 0
        default:
            segmentedControl.selectedSegmentIndex = 1
        }
    }
    
    func configureRulerView(scale: DTRuler.Scale) {
        valueLabel.text = scale.minorTextRepresentation()
        rulerViewDataSource(scale: scale, unitLimit: .init(unitType.unitLimit.0))
    }
    
    private func rulerViewDataSource(scale: DTRuler.Scale, unitLimit: Int) {
        rulerView.scale = scale
        rulerView.layoutRuler(with: scale, .integer(10), .integer(unitLimit), bounds.width - 50)
        rulerView.layoutPointer()
    }
}

//extension PersonalSliderView: UIPickerViewDelegate, UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        valueLabel.text = String(row % unitType.unitLimit.0)
//        return String(row % unitType.unitLimit.0)
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return pickerDataSize
//    }
//}

extension PersonalSliderView: DTRulerDelegate {
    
    struct Colorful: DTRulerTheme {
        var backgroundColor: UIColor {
            return UIColor(white: 1, alpha: 1)
        }
        var pointerColor: UIColor {
            return R.color.purple() ?? UIColor.purple
        }
        
        var majorScaleColor: UIColor {
            return R.color.purple() ?? UIColor.purple
        }
        
        var minorScaleColor: UIColor {
            return R.color.purple()?.withAlphaComponent(0.5) ?? UIColor.purple.withAlphaComponent(0.5)
        }
    }
    
    func didChange(on ruler: DTRuler, withScale scale: DTRuler.Scale) {
        if segmentedControl.selectedSegmentIndex == 0 {
            valueLabel.text = unitType == .height ? "\(scale.minorTextRepresentation()) cm" : "\(scale.minorTextRepresentation()) lb"
        } else {
            valueLabel.text = unitType == .height ? "\(scale.minorTextRepresentation()) inch" : "\(scale.minorTextRepresentation()) kg"
        }
        rulerValueDidChange?(scale.minorTextRepresentation())
    }
}
