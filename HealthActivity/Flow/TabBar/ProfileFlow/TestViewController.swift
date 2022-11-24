//
//  TestViewController.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 24/11/22.
//

import Foundation
import DTRuler
import UIKit

class TestViewController: BaseController {
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "10"
        return label
    }()
    
//    private lazy var rulerView: DTRuler = {
//        let ruler = DTRuler(scale: .integer(10), minScale: .integer(0), maxScale: .integer(100), width: view.bounds.width - 50)
//        ruler.delegate = self
//        return ruler
//    }()
    
    private var rulerView: DTRuler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
        }
        layoutRuler()
    }
    
    fileprivate func layoutRuler() {
        guard let text = label.text, let scale = Int(text) else {
          return
        }
        
        DTRuler.theme = Colorful()
        
        let rulerView = DTRuler(scale: .integer(scale), minScale: .integer(10), maxScale: .integer(100), width: view.bounds.width - 50)
        rulerView.delegate = self
        
        view.addSubview(rulerView)
        rulerView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(100)
            make.left.equalTo(view.snp.left).inset(25)
            make.right.equalTo(view.snp.right).inset(25)
        }
    }
    
    struct Colorful: DTRulerTheme {
        
        var backgroundColor: UIColor {
            return UIColor(white: 1, alpha: 0.3)
        }
        
        var pointerColor: UIColor {
            return UIColor(red:0.47, green:0.30, blue:0.51, alpha:1.00)
        }
        
    }
    
}

extension TestViewController: DTRulerDelegate {
    
    public func didChange(on ruler: DTRuler, withScale scale: DTRuler.Scale) {
        label.text = scale.minorTextRepresentation()
    }
}

