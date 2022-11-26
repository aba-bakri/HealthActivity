//
//  WalkViewController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 26/11/22.
//

import UIKit
import RxCocoa
import RxSwift

class WalkViewController: BaseController {
    
    internal var router: WalkRouter?
    internal var viewModel: WalkViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindUI() {
        super.bindUI()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = WalkViewModel.Input()
        let output = viewModel.transform(input: input)
        
        
    }
}
