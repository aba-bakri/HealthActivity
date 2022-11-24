//
//  SplashViewController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 17/11/22.
//

import UIKit
import AuthenticationServices

class SplashViewController: BaseController, ASAuthorizationControllerDelegate {
    
    private lazy var logoView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(named: "purple")
        return view
    }()
    
    internal var router: SplashRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getInitialViewController()
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        view.addSubview(logoView)
        logoView.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
            make.width.height.equalTo(200)
        }
    }
    
    private func getInitialViewController() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: UserDefaultStorage.userIdentifier) {  (credentialState, error) in
            switch credentialState {
            case .authorized:
                self.showLoader()
                DispatchQueue.main.async {
                    let controller = AppBuilder.getMainTabBarController()
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true) {
                        self.hideLoader()
                    }
                }
            case .revoked:
                print("Apple ID credential is revoked.")
                fallthrough
            case .notFound:
                self.showLoader()
                DispatchQueue.main.async {
                    let controller = AppBuilder.loadOnboardingController(delegate: self)
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true) {
                        self.hideLoader()
                    }
                }
            default:
                break
            }
        }
    }
}

extension SplashViewController: OnboardingDelegate {
    func dismissToTabBar() {
        self.showLoader()
        let controller = AppBuilder.getMainTabBarController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true) {
            self.hideLoader()
        }
    }
    
    func checkAuthCredential() {
        getInitialViewController()
    }
}
