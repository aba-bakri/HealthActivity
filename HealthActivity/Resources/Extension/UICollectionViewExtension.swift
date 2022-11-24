//
//  UICollectionViewExtension.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 16/11/22.
//

import UIKit

public protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    public static var reuseIdentifier: String {
        ///Implementing reuseIdentifier for easier using identifier in view nibname
        ///It helps not to think about naming of identifier to view
        return String(describing: self)
    }
}

extension UICollectionViewCell: Reusable { }
extension UICollectionReusableView: Reusable { }

extension UICollectionView {
    
    ///Register Reusable Cell
    public func registerReusableCell<T: UICollectionViewCell>(_: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    public func dequeueReusableCell<T: Reusable>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        return cell
    }
}

extension UICollectionView {
    ///Register Reusable Header Footer
    
    public func registerReusableHeader<T: UICollectionReusableView>(_: T.Type) {
        self.register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
    }
    
    public func registerReusableFooter<T: UICollectionReusableView>(_: T.Type) {
        self.register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier)
    }
    
    public func dequeueReusableHeader<T: Reusable>(indexPath: IndexPath) -> T {
        guard let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Collection View Header")
        }
        return header
    }
    
    public func dequeueReusableFooter<T: Reusable>(indexPath: IndexPath) -> T {
        guard let footer = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Collection View Header")
        }
        return footer
    }
}

