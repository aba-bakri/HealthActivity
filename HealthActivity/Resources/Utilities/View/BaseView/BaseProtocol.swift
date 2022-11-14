//
//  BaseProtocol.swift
//  ComponentsUI
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import Foundation

public protocol Setupable: AnyObject {
    func setupControl()
    func setupComponentsUI()
}

public protocol Tapable {
    typealias TapBlock = () -> Void
    
    /// Implement tapBlock in buttons and other components
    ///
    /// ```
    /// control.didTap = { [weak self] in
    ///
    /// }
    /// ```
    /// - Warning: If you are using `self` in block please use `weak self`
    var didTapBlock: TapBlock? { get set}
}
