//
//  BaseController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 8/11/22.
//

import UIKit
import RxCocoa
import RxSwift

open class BaseController: ViewController {
    
    internal lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        return scrollView
    }()
    
    internal lazy var contentView: BaseView = {
        let view = BaseView(frame: .zero)
        view.backgroundColor = R.color.background()
        return view
    }()
    
    internal let disposeBag = DisposeBag()
    
    open override func loadView() {
        super.loadView()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    open func setupNavigationBar() { }
    
    open override func setupControl() {
        super.setupControl()
        view.backgroundColor = R.color.background()
    }
    
    open override func setupComponentsUI() {
        super.setupComponentsUI()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.snp.edges)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(scrollView.snp.height).priority(.low)
        }
    }
    
    func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        contentView.addGestureRecognizer(tap)
    }
    
    @objc private func endEditing() {
        contentView.endEditing(true)
    }
    
}
