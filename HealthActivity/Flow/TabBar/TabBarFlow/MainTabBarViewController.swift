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
    case status
    case profile
    
    var tabbarItem: UITabBarItem {
        return UITabBarItem(title: nil, image: self.tabBarImage, selectedImage: self.tabBarImage)
    }
    
    private var tabBarImage: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "home")
        case .activities:
            return UIImage(named: "activities")
        case .status:
            return UIImage(named: "status")
        case .profile:
            return UIImage(named: "profile")
        }
    }
    
    private var tabBarSelectedImage: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "home")
        case .activities:
            return UIImage(named: "activities")
        case .status:
            return UIImage(named: "status")
        case .profile:
            return UIImage(named: "profile")
        }
    }
    
    var controller: UIViewController {
        switch self {
        case .home:
            let build = HomeBuild.build()
            build.tabBarItem = tabbarItem
            return build
        case .activities:
            let build = HomeBuild.build()
            build.tabBarItem = tabbarItem
            return build
        case .status:
            let build = HomeBuild.build()
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
    
    private let mainTabBar = MainTabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControl()
    }
    
    override func setupControl() {
        super.setupControl()
//        setValue(MainTabBar(frame: self.tabBar.frame), forKey: "tabBar")
        self.setViewControllers(TabBarItem.allCases.map { BaseNavigationController(rootViewController: $0.controller) }, animated: false)
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.tintColor = UIColor(named: "purple")
        self.tabBar.unselectedItemTintColor = UIColor(named: "lightGray")
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
