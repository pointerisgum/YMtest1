//
//  UIBShadowView.swift
//  Dada
//
//  Created by 김영민 on 2021/07/29.
//

import UIKit

extension UIBShadowView: IIBShadow {}

@IBDesignable class UIBShadowView: UMView {
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            applyShadow()
        }
    }
    @IBInspectable var shadowBlur: CGFloat = 0.0 {
        didSet {
            applyShadow()
        }
    }
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 1) {
        didSet {
            applyShadow()
        }
    }
    
    override func doLayout() {
        super.doLayout()

        applyShadow()
    }

}
