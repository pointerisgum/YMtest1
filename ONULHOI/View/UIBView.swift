//
//  UIBView.swift
//  Lulla
//
//  Created by Mac on 2018. 1. 30..
//  Copyright © 2018년 pplus. All rights reserved.
//

import UIKit

extension UIBView: IIBCorner, IIBBorder, IIBShadow {}

@IBDesignable class UIBView: UMView {
	
	@IBInspectable var cornerRadius: CGFloat = 0 {
		didSet {
			applyCorner()
		}
	}
	
	@IBInspectable var borderColor: UIColor = .clear {
		didSet {
			applyBorder()
		}
	}
	@IBInspectable var borderWidth: CGFloat = 0 {
		didSet {
			applyBorder()
		}
	}

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
		
		applyCorner()
		applyBorder()
//		applyShadow()
	}

}
