//
//  ProfileViewController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit
import HealthKit
import AuthenticationServices
import RxSwift
import RxCocoa

class ProfileViewController: BaseController, PersonalInfoDelegate {
    
    private lazy var profileInfoView: ProfileInfoView = {
        let view = ProfileInfoView(frame: .zero)
        return view
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = R.color.blackLabel()
        label.text = "Today"
        return label
    }()
    
    private lazy var walkView: InfoView = {
        let view = InfoView(type: .walk)
        return view
    }()
    
    private lazy var heartView: InfoView = {
        let view = InfoView(type: .heart)
        return view
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 14
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(walkView)
        stackView.addArrangedSubview(heartView)
        return stackView
    }()
    
    private lazy var sleepView: InfoView = {
        let view = InfoView(type: .sleep)
        return view
    }()
    
    private lazy var caloriesView: InfoView = {
        let view = InfoView(type: .calories)
        return view
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 14
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(sleepView)
        stackView.addArrangedSubview(caloriesView)
        return stackView
    }()
    
    private lazy var leftBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "notification"), style: .plain, target: self, action: #selector(notificationAction))
        return button
    }()
    
    private lazy var signInBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Sign In", style: .plain, target: self, action: #selector(signInAction))
        return button
    }()
    
    private lazy var signOutBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutAction))
        return button
    }()
    
    internal var router: ProfileRouter?
    internal var viewModel: ProfileViewModel!
    
    private let dateSubject = BehaviorSubject<Date>(value: Date())
    private let heightUnitSubject = BehaviorSubject<HeightUnit>(value: UserDefaultStorage.heightUnit)
    private let weightUnitSubject = BehaviorSubject<WeightUnit>(value: UserDefaultStorage.weightUnit)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.leftBarButtonItem = leftBarButton
        if (UserDefaultStorage.email?.isEmpty ?? true) {
            navigationItem.rightBarButtonItem = signInBarButton
        }
    }

    override func setupControl() {
        super.setupControl()
        profileInfoView.moreButton.didTapBlock = { [weak self] in
            guard let self = self else { return }
            self.router?.navigateToPersonalInfo(delegate: self)
        }
    }
    
    func updateHeightWeight(height: UpdateHeight?, weight: UpdateWeight?) {
        self.heightUnitSubject.onNext(height?.heightUnit ?? .cm)
        self.weightUnitSubject.onNext(weight?.weightUnit ?? .pound)
        self.profileInfoView.heightView.configureHeightView(value: height?.height.toString ?? "")
        self.profileInfoView.weightView.configureWeightView(value: weight?.weight.toString ?? "")
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = ProfileViewModel.Input(date: dateSubject.asObservable(),
                                           weightUnit: weightUnitSubject.asObservable(),
                                           heightUnit: heightUnitSubject.asObservable())
        let output = viewModel.transform(input: input)
        
        output.navigationTitleSubject.drive(onNext: { [weak self] title in
            guard let self = self else { return }
            self.navigationItem.title = title
        }).disposed(by: disposeBag)
        
        output.walkSubject.drive(onNext: { [weak self] steps in
            guard let self = self else { return }
            self.walkView.valueLabel.text = steps.toString
        }).disposed(by: disposeBag)
        
        output.heightSubject.drive(onNext: { [weak self] unit, height in
            guard let self = self else { return }
            self.profileInfoView.heightView.configureHeightView(value: height.toString)
        }).disposed(by: disposeBag)
         
        output.weightSubject.drive(onNext: { [weak self] unit, weight in
            guard let self = self else { return }
            self.profileInfoView.weightView.configureWeightView(value: weight.toString)
        }).disposed(by: disposeBag)
        
        output.caloriesSubject.drive(onNext: { [weak self] calories in
            guard let self = self else { return }
            self.caloriesView.valueLabel.text = calories.toString
        }).disposed(by: disposeBag)
        
        output.heartRateSubject.drive(onNext: { [weak self] heartRate in
            guard let self = self else { return }
            self.heartView.configureValueLabel(value: heartRate)
        }).disposed(by: disposeBag)
        
        output.sleepSubject.drive(onNext: { [weak self] hours in
            guard let self = self else { return }
            self.sleepView.valueLabel.text = hours
        }).disposed(by: disposeBag)
        
        output.errorSubject.drive(onNext: { [weak self] error in
            guard let self = self else { return }
            self.heartView.configureError(value: error)
        }).disposed(by: disposeBag)
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        contentView.addSubview(profileInfoView)
        profileInfoView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(14)
            make.left.equalTo(contentView.snp.left).inset(14)
            make.right.equalTo(contentView.snp.right).inset(14)
            make.height.equalTo(193)
        }
        
        contentView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(profileInfoView.snp.bottom).offset(30)
            make.left.equalTo(contentView.snp.left).inset(14)
        }
        
        contentView.addSubview(topStackView)
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(20)
            make.left.equalTo(contentView.snp.left).inset(14)
            make.right.equalTo(contentView.snp.right).inset(14)
        }
        
        contentView.addSubview(bottomStackView)
        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(14)
            make.left.equalTo(contentView.snp.left).inset(14)
            make.right.equalTo(contentView.snp.right).inset(14)
            make.bottom.equalTo(contentView.snp.bottom).inset(14)
        }

        [walkView, heartView, sleepView, caloriesView].forEach { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(145)
            }
        }
    }
    
    @objc private func notificationAction() { }
    
    @objc private func signInAction() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    @objc private func signOutAction() { }
}

extension ProfileViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension ProfileViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            UserDefaultStorage.userIdentifier = appleIDCredential.user
            UserDefaultStorage.firstName = "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")"
            UserDefaultStorage.email = appleIDCredential.email
            dismiss(animated: true)
            break
        default:
            self.showErrorAlert(title: "Error", message: "Sign In Error")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.showErrorAlert(title: "Error", message: error.localizedDescription)
    }
}
