////
////  AuthService.swift
////  HealthActivity
////
////  Created by Ababakri Ibragimov on 17/11/22.
////
//
//import AuthenticationServices
//import Foundation
//import RxSwift
//
//enum AuthToken {
//    case apple(code: String, name: String)
//}
//
//protocol AuthProviderProtocol {
//    var authResult: Observable<AuthToken> { get }
//
//    func login()
//    func logout()
//}
//
//@available(iOS 13.0, *)
//class AppleAuthService: AuthProviderProtocol {
//
//    private let authResultSubject = PublishSubject<AuthToken>()
//    var authResult: Observable<AuthToken> {
//        return authResultSubject.asObservable()
//    }
//
//    func login() {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.performRequests()
//    }
//
//    func logout() {
//        <#code#>
//    }
//
//
//
//}
//
//@available(iOS 13.0, *)
//extension AppleAuthService: ASAuthorizationControllerDelegate {
//
//    func authorizationController(
//        controller: ASAuthorizationController,
//        didCompleteWithAuthorization authorization: ASAuthorization
//    ) {
//        guard
//            let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
//            let tokenData = credential.authorizationCode,
//            let token = String(data: tokenData, encoding: .utf8)
//        else { return }
//
//        let firstName = credential.fullName?.givenName ?? ""
//        let lastName = credential.fullName?.familyName ?? ""
//
//        authResultSubject.onNext(.apple(code: token, name: firstName + lastName))
//    }
//
//}
