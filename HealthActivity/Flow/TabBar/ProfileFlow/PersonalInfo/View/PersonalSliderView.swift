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
    
    public var rulerValueDidChange: ((String) -> Void)?
    private lazy var initialValue: Int = .zero
    
    private var unitType: HeightWeightType
    
    private lazy var rulerView: DTRuler = {
        let ruler = DTRuler(scale: .integer(initialValue), minScale: .integer(30), maxScale: .integer(unitType.unitLimit.0), width: bounds.width - 50)
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
        }
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
    
    @objc private func segmentedControlValueChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            var value = (Double(initialValue) * 2.54)
            rulerViewDataSource(scale: .integer(value.toInt), unitLimit: unitType.unitLimit.0)
        } else {
            var value = (Double(initialValue) * 0.393701)
            rulerViewDataSource(scale: .integer(value.toInt), unitLimit: unitType.unitLimit.1)
        }
    }
    
    func configureRulerView(value: Int) {
        let scale = DTRuler.Scale.integer(value)
        initialValue = value
        valueLabel.text = scale.minorTextRepresentation()
        rulerViewDataSource(scale: scale, unitLimit: unitType.unitLimit.0)
    }
    
    private func rulerViewDataSource(scale: DTRuler.Scale, unitLimit: Int) {
        rulerView.scale = scale
        rulerView.layoutRuler(with: scale, .integer(10), .integer(unitLimit), bounds.width - 50)
        rulerView.layoutPointer()
    }
}

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
