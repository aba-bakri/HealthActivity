//
//  OnboardingCell.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 19/11/22.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = R.color.purple()
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.textColor = UIColor.white
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 74
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        return stackView
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
        contentView.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges)
        }
        
        contentView.addSubview(titleStackView)
        titleStackView.snp.makeConstraints { make in
            make.center.equalTo(contentView.snp.center)
            make.left.equalTo(contentView.snp.left).inset(25)
            make.right.equalTo(contentView.snp.right).inset(25)
        }
    }
    
    func configureCell(item: OnboardingItem) {
        backgroundImage.image = item.backgroundImage
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }
}
