//
//  ProgressCell.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 16/11/22.
//

import UIKit
import MLVerticalProgressView

class ProgressCell: UICollectionViewCell, Setupable {
    
    private lazy var verticalProgressView: VerticalProgressView = {
        let view = VerticalProgressView(frame: .zero)
        view.setCornerRadius(corners: .allCorners, radius: 5)
        return view
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(named: "grayLabel")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupControl()
        setupComponentsUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupControl() {
    }
    
    func setupComponentsUI() {
        contentView.addSubview(verticalProgressView)
        verticalProgressView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left).inset(4)
            make.right.equalTo(contentView.snp.right).inset(4)
            make.height.equalTo(162)
        }
        
        contentView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(verticalProgressView.snp.bottom).offset(14)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    func configureCell(type: StatusType, model: StatusProgressModel?) {
        verticalProgressView.fillDoneColor = type.progressLineColor ?? .purple
        dayLabel.text = model?.day
        
        let progress = Double(Double(Double((model?.heartBPM ?? .zero) * 100) / 220) / 100)
        verticalProgressView.setProgress(progress: Float(progress), animated: true)
    }
}
