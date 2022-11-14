//
//  UIViewControllerExtension.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 10/11/22.
//

import Foundation
import UIKit

typealias AlertAction = (() -> Void)

extension UIViewController {
    
    func showAlert(title: String? = nil, message: String? = nil, alertAction: (AlertAction)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.overrideUserInterfaceStyle = .dark
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
            alertAction?()
        }))
        present(alertController, animated: true)
    }
    
    func showErrorAlert(title: String? = "Ошибка", message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.overrideUserInterfaceStyle = .dark
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self] _ in
            guard let self = self else { return }
            if (message ?? "").contains("Сессия окончена") {
//                self.removeAllStorage()
//                self.dismissTo(vc: AppBuilder.getInitialViewController(), count: nil, animated: true)
            }
        }))
        present(alertController, animated: true)
    }
    
    func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func endEditing() {
        view.endEditing(true)
    }
    
    func dismissTo(vc: UIViewController?, count: Int?, animated: Bool, completion: (() -> Void)? = nil) {
        var loopCount = 0
        var dummyVC: UIViewController? = self
        for _ in 0..<(count ?? 100) {
            loopCount = loopCount + 1
            dummyVC = dummyVC?.presentingViewController
            if let dismissToVC = vc {
                if dummyVC != nil && dummyVC!.isKind(of: dismissToVC.classForCoder) {
                    dummyVC?.dismiss(animated: animated, completion: completion)
                }
            }
        }
        
        if count != nil {
            dummyVC?.dismiss(animated: animated, completion: completion)
        }
    }
}
