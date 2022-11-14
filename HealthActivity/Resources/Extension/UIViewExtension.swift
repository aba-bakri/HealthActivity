//
//  UIViewExtension.swift
//  ComponentsUI
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit

extension UIView {
    
    /// setCornerRadius method is used to round corners for any subclasses  of UIView (UILabel, UIButton and etc.)
    public func setCornerRadius(corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            var cornerMask: CACornerMask = []
            if corners.contains(.topLeft) {
                cornerMask.insert(.layerMinXMinYCorner)
            }
            if corners.contains(.topRight) {
                cornerMask.insert(.layerMaxXMinYCorner)
            }
            if corners.contains(.bottomLeft) {
                cornerMask.insert(.layerMinXMaxYCorner)
            }
            if corners.contains(.bottomRight) {
                cornerMask.insert(.layerMaxXMaxYCorner)
            }
            self.layer.maskedCorners = cornerMask
        } else {
            let rectShape = CAShapeLayer()
            rectShape.bounds = frame
            rectShape.position = center
            rectShape.path = UIBezierPath(roundedRect: bounds,
                                          byRoundingCorners: corners,
                                          cornerRadii: CGSize(width: radius, height: radius)).cgPath
            self.layer.mask = rectShape
        }
    }
    
    /// setShadow method is used to add shadow for any subclasses  of UIView (UILabel, UIButton and etc.)
    public func setShadow(color: UIColor = .white, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layoutIfNeeded()
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = 0.1
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                             cornerRadius: self.layer.cornerRadius).cgPath
    }
    
    public func setBorderColor(color: UIColor?, radius: CGFloat) {
        self.layer.borderWidth = 1
        self.layer.borderColor = color?.cgColor
        self.layer.cornerRadius = radius
    }
}
