//
//  BaseCollectionView.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 16/11/22.
//

import Foundation
import UIKit

///Implementing SHBasicTableViewProtocol for easier creation tableView with Item and Cell
///where item is Generic object data for cell, and Cell is the cell in tableView
public protocol BaseCollectionViewProtocol {
    
    associatedtype Item
    associatedtype Cell: UICollectionViewCell
    
    var collectionView: BaseCollectionView<Item, Cell> { get }
}

open class BaseCollectionView<Item, Cell: UICollectionViewCell>: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public typealias Item = Item
    
    private var items = [Item]()
    
    ///Implementing cell config closure to handle cell data configuration to display data
    ///where item is Generic object data for cell, and Cell is the cell in tableView
    /// ```
    /// cell.config = { [weak self] item, indexPath in
    /// }
    /// ```
    /// - Warning: If you are using `self` in block please use `weak self`
    public var config: ((Item, Cell) -> ())?
    
    ///Implementing cell didTapBlock closure to handle cell didSelect action
    ///where item is Generic object data for cell, and IndexPath is index of cell in tableView
    /// ```
    /// cell.didTapBlock = { [weak self] item, indexPath in
    /// }
    /// ```
    /// - Warning: If you are using `self` in block please use `weak self`
    public var didTapBlock: ((Item, IndexPath) -> ())?
    
    public var didEndScrolling: ((UIScrollView) -> ())?
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupControl()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
        self.dataSource = self
        self.registerReusableCell(Cell.self)
    }
    
    //MARK: Setup Cell
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: Cell = dequeueReusableCell(for: indexPath)
        config?(items[indexPath.row], cell)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapBlock?(items[indexPath.row], indexPath)
    }
    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return cellFrame
//    }
    
    // MARK: Setupable
    open func setupControl() {
        setupCollectionView()
    }
    
    public func reload(data items: [Item]) {
        self.items = items
        self.reloadData()
    }
    
    public func configureCell(cellItems: [Item], cellConfig: ((Item, Cell) -> ())?, cellDidTapBlock: ((Item, IndexPath) -> ())? = nil) {
        self.items = cellItems
        self.config = cellConfig
        self.didTapBlock = cellDidTapBlock
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.didEndScrolling?(scrollView)
    }
}
