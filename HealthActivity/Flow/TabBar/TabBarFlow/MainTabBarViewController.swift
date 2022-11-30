//
//  MainTabBarViewController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit

enum TabBarItem: CaseIterable {
    case home
    case activities
    case go
    case status
    case profile
    
    var tabbarItem: UITabBarItem {
        return UITabBarItem(title: nil, image: self.tabBarImage, selectedImage: self.tabBarImage)
    }
    
    private var tabBarImage: UIImage? {
        switch self {
        case .home:
            return R.image.home()
        case .activities:
            return R.image.activities()
        case .go:
            return nil
        case .status:
            return R.image.status()
        case .profile:
            return R.image.profile()
        }
    }
    
    private var tabBarSelectedImage: UIImage? {
        switch self {
        case .home:
            return R.image.home()
        case .activities:
            return R.image.activities()
        case .go:
            return nil
        case .status:
            return R.image.status()
        case .profile:
            return R.image.profile()
        }
    }
    
    var controller: UIViewController {
        switch self {
        case .home:
            let build = HomeBuild.build()
            build.tabBarItem = tabbarItem
            return build
        case .activities:
            let build = ActivityBuild.build()
            build.tabBarItem = tabbarItem
            return build
        case .go:
            let build = WalkBuild.build()
            return build
        case .status:
            let build = StatusBuild.build()
            build.tabBarItem = tabbarItem
            return build
        case .profile:
            let build = ProfileBuild.build()
            build.tabBarItem = tabbarItem
            return build
        }
    }
}

class MainTabBarViewController: BaseTabBarViewController {
    
    private let healthManager = HealthManager.shared
    
    private lazy var goButton: BaseClearButton = {
        let button = BaseClearButton(frame: .zero)
        button.backgroundColor = R.color.purple()
        button.setTitle("GO", for: .normal)
        button.setCornerRadius(corners: .allCorners, radius: 30)
        button.didTapBlock = { [weak self] in
            guard let self = self else { return }
            let walkBuild = WalkBuild.build()
            self.navigationController?.pushViewController(walkBuild, animated: true)
        }
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControl()
        authorizeHealthKit()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.addSubview(goButton)
        goButton.snp.makeConstraints { make in
            make.centerY.equalTo(tabBar.snp.top)
            make.centerX.equalTo(tabBar.snp.centerX)
            make.height.width.equalTo(60)
        }
    }
    
    private func authorizeHealthKit() {
        healthManager.authorizeHealthKit(success: nil) { [weak self] error in
            guard let self = self else { return }
            self.showErrorAlert(title: "Error", message: error.errorDescription)
        }
    }
    
    override func setupControl() {
        super.setupControl()
        self.delegate = self
        self.setViewControllers(TabBarItem.allCases.map { BaseNavigationController(rootViewController: $0.controller) }, animated: false)
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.tintColor = R.color.purple()
        self.tabBar.unselectedItemTintColor = R.color.lightGray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

}

extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        if selectedIndex == 2 {
            return false
        } else {
            return true
        }
    }
}
