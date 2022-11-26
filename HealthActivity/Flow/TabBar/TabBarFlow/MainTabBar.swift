////
////  MainTabBar.swift
////  HealthActivity
////
////  Created by Ababakri Ibragimov on 8/11/22.
////
//
//import UIKit
//
//class MainTabBar: UITabBar {
//
//    internal var goButtonTap: (() -> Void)?
//
//    private lazy var goButton: BaseClearButton = {
//        let button = BaseClearButton(frame: .zero)
//        button.backgroundColor = UIColor(named: "purple")
//        button.setTitle("GO", for: .normal)
//        button.setCornerRadius(corners: .allCorners, radius: 30)
//        button.didTapBlock = { [weak self] in
//            guard let self = self else { return }
//            self.goButtonTap?()
//        }
//        return button
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setShadow(radius: .zero)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        addSubview(goButton)
//        goButton.snp.makeConstraints { make in
//            make.centerY.equalTo(snp.top)
//            make.centerX.equalTo(snp.centerX)
//            make.height.width.equalTo(60)
//        }
//    }
//
//    // MARK: - HitTest
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
//        return goButton.frame.contains(point) ? goButton : super.hitTest(point, with: event)
//    }
//}
