//
//  BaseRouter.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import Foundation

public class BaseRouter {
    private weak var viewController: UIViewController?

    var previousViewController: UIViewController? {
            if let controllersOnNavStack = viewController?.navigationController?.viewControllers,
               controllersOnNavStack.count >= 2 {
                let controllersCount = controllersOnNavStack.count
                return controllersOnNavStack[controllersCount - 2]
            }
            return nil
        }

    var currentViewControllers: [UIViewController]? {
        return viewController?.navigationController?.viewControllers
    }

    var getOwnerViewController: UIViewController? {
        return viewController
    }

    init(viewController: UIViewController?) {
        self.viewController = viewController
    }

    func push(viewController target: UIViewController, animated: Bool = true) {
        viewController?.navigationController?.pushViewController(target, animated: animated)
    }

    func present(viewController target: UIViewController) {
        viewController?.present(target, animated: true)
    }
    
    func presentRoot(viewController target: UIViewController, modalPresentationStyle: UIModalPresentationStyle = .pageSheet) {
        target.modalPresentationStyle = modalPresentationStyle
        UIApplication.shared.windows.first?.rootViewController = target
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func present(viewController target: UIViewController, modalPresentationStyle: UIModalPresentationStyle) {
        target.modalPresentationStyle = modalPresentationStyle
        viewController?.present(target, animated: true)
    }

    func dismiss(completion: (() -> Void)? = nil) {
        viewController?.dismiss(animated: true, completion: completion)
    }

    func pop(animated: Bool = true) {
        viewController?.navigationController?.popViewController(animated: animated)
    }

    func root(viewController target: UIViewController, animated: Bool = true) {
        viewController?.navigationController?.setViewControllers([target], animated: animated)
    }

    func root(viewControllers targets: [UIViewController], animated: Bool = true) {
        viewController?.navigationController?.setViewControllers(targets, animated: animated)
    }

    func popTo<ViewControllerType>(typeVC: ViewControllerType.Type, animated: Bool = true) {
        guard let controllers =  viewController?.navigationController?.viewControllers else {
            return
        }

        for obj in controllers where obj is ViewControllerType {
            viewController?.navigationController?.popToViewController(obj, animated: true)
        }
    }

    func popTo<UIViewController>(vc: UIViewController.Type, animated: Bool = true) -> Bool {
        guard let controllers =  viewController?.navigationController?.viewControllers else {
            return false
        }

        guard let controller = controllers.first(where: { type(of: $0) == vc }) else {
            return false
        }

        viewController?.navigationController?.popToViewController(controller, animated: true)
        return true
    }

    func replaceLast(viewController target: UIViewController) {
        guard
            let vc = viewController,
            let nc = (vc.navigationController ?? vc.presentingViewController) as? SHNavigationController
        else { return }

        guard vc.presentingViewController == nil else {
            vc.dismiss(animated: true, completion: {
                nc.pushViewController(target, animated: true)
            })
            return
        }

        var stack = nc.viewControllers
        stack.removeLast()
        stack.append(target)
        nc.setViewControllers(stack, animated: true)
    }
}
