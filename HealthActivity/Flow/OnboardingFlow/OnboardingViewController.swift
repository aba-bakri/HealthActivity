//
//  OnboardingViewController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 19/11/22.
//

import UIKit
import AuthenticationServices

protocol OnboardingDelegate {
    func dismissToTabBar()
    func checkAuthCredential()
}

class OnboardingViewController: BaseController, BaseCollectionViewProtocol {
    
    typealias Item = OnboardingItem
    typealias Cell = OnboardingCell
    
    internal var router: OnboardingRouter?
    internal var viewModel: OnboardingViewModel!
    
    internal lazy var collectionView: BaseCollectionView<OnboardingItem, OnboardingCell> = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        let collectionView = BaseCollectionView<OnboardingItem, OnboardingCell>(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.black
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: .zero)
        pageControl.numberOfPages = OnboardingItem.allCases.count
        pageControl.currentPage = 0
        return pageControl
    }()
    
    private lazy var guestButton: BaseButton = {
        let button = BaseButton(frame: .zero)
        button.isEnabled = true
        button.setTitle("GUEST", for: .normal)
        button.didTapBlock = { [weak self] in
            guard let self = self else { return }
            self.guestAction()
        }
        return button
    }()
    
    private lazy var signInWithAppleButton: BaseClearButton = {
        let button = BaseClearButton(frame: .zero)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setBorderColor(color: R.color.purple(), radius: 24, borderWidth: 2)
        button.backgroundColor = UIColor.clear
        button.setTitle("SIGN IN WITH APPLE", for: .normal)
        button.didTapBlock = { [weak self] in
            guard let self = self else { return }
            self.handleAppleIdRequest()
        }
        return button
    }()
    
    private lazy var signInStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 26
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(guestButton)
        stackView.addArrangedSubview(signInWithAppleButton)
        return stackView
    }()
    
    private lazy var privacyPolicyButton: BaseClearButton = {
        let button = BaseClearButton(frame: .zero)
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    private lazy var termOfUseButton: BaseClearButton = {
        let button = BaseClearButton(frame: .zero)
        button.setTitle("Terms of use  ", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    private lazy var rulesStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 100
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(privacyPolicyButton)
        stackView.addArrangedSubview(termOfUseButton)
        return stackView
    }()
    
    private lazy var generalStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 33
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(pageControl)
        stackView.addArrangedSubview(signInStackView)
        stackView.addArrangedSubview(rulesStackView)
        return stackView
    }()
    
    internal var delegate: OnboardingDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupControl() {
        super.setupControl()
        setupCollectionView()
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        scrollView.snp.remakeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
        
        view.addSubview(generalStackView)
        generalStackView.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).inset(14)
            make.right.equalTo(view.snp.right).inset(14)
            make.bottom.equalTo(view.snp.bottom).inset(48)
        }

        pageControl.snp.makeConstraints { make in
            make.height.equalTo(15)
        }

        [guestButton, signInWithAppleButton].forEach { button in
            button.snp.makeConstraints { make in
                make.height.equalTo(48)
            }
        }
    }
    
    private func setupCollectionView() {
        let items = OnboardingItem.allCases
        collectionView.configureCell(cellItems: items) { item, cell in
            cell.configureCell(item: item)
        }
        collectionView.reload(data: items)
        collectionView.didEndScrolling = { [weak self] scrollView in
            guard let self = self else { return }
            self.pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
    }
    
    private func guestAction() {
        dismiss(animated: true) {
            self.delegate?.dismissToTabBar()
        }
    }
    
    @objc private func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension OnboardingViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension OnboardingViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            UserDefaultStorage.userIdentifier = appleIDCredential.user
            UserDefaultStorage.firstName = "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")"
            UserDefaultStorage.email = appleIDCredential.email
            dismiss(animated: true) {
                self.delegate?.checkAuthCredential()
            }
            break
        default:
            self.showErrorAlert(title: "Error", message: "Sign In Error")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.showErrorAlert(title: "Error", message: error.localizedDescription)
    }
}
