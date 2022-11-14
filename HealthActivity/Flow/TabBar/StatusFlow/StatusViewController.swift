//
//  StatusViewController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 10/11/22.
//

import UIKit

class StatusViewController: BaseController {
    
    private lazy var heartStatusView: StatusView = {
        let view = StatusView(type: .heart)
        return view
    }()
    
    private lazy var sleepStatusView: StatusView = {
        let view = StatusView(type: .sleep)
        return view
    }()
    
    private lazy var statusStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(heartStatusView)
        stackView.addArrangedSubview(sleepStatusView)
        return stackView
    }()
    
    internal var router: StatusRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupControl() {
        super.setupControl()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "Status For Week"
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        contentView.addSubview(statusStackView)
        statusStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges).inset(14)
        }
        
        [heartStatusView, sleepStatusView].forEach { statusView in
            statusView.snp.makeConstraints { make in
                make.height.equalTo(390)
            }
        }
    }
    
}
