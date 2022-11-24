//
//  StatusProgressView.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 16/11/22.
//

import UIKit

class StatusProgressView: BaseView, BaseCollectionViewProtocol {
    
    typealias Item = StatusProgressModel?
    typealias Cell = ProgressCell
    
    internal lazy var collectionView: BaseCollectionView<StatusProgressModel?, ProgressCell> = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 30, height: 190)
        let collectionView = BaseCollectionView<StatusProgressModel?, ProgressCell>(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let statusType: StatusType
    
    init(type: StatusType) {
        self.statusType = type
        super.init(frame: .zero)
        setupControl()
        setupComponentsUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupControl() {
        super.setupControl()
    }
    
    override func setupComponentsUI() {
        super.setupComponentsUI()
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left).inset(14)
            make.right.equalTo(snp.right).inset(14)
            make.bottom.equalTo(snp.bottom)
        }
    }
    
    func setupCollectionView(items: [StatusProgressModel?]) {
        collectionView.configureCell(cellItems: items) { item, cell in
            cell.configureCell(type: self.statusType, model: item)
        }
        collectionView.reload(data: items)
    }
    
}
