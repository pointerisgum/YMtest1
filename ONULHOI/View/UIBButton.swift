//
//  UIBButton.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 22..
//  Copyright © 2017년 pplus. All rights reserved.
//

import UIKit

extension UIBButton: IIBCorner, IIBBorder, IIBShadow, IIBStretchable {}

@IBDesignable
final class UIBButton: UMButton {
	
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
	
	@IBInspectable var stretchableEnable: Bool = true {
		didSet {
			applyStretchable()
		}
	}
	
	@IBInspectable var stretchablePoint: CGPoint = .zero {
		didSet {
			applyStretchable()
		}
	}
	
    @IBInspectable var selectedBackgroundColor: UIColor = .white {
        didSet {
            self.setBackgroundColor(normalBackgroundColor, for: .selected)
        }
    }
    
    @IBInspectable var normalBackgroundColor: UIColor = .white {
        didSet {
            self.setBackgroundColor(normalBackgroundColor, for: .normal)
        }
    }

    @IBInspectable var selectedTextColor: UIColor = .white {
        didSet {
            self.setTitleColor(selectedTextColor, for: .selected)
        }
    }

    @IBInspectable var normalTextColor: UIColor = .white {
        didSet {
            self.setTitleColor(normalTextColor, for: .normal)
        }
    }

	override func doLayout() {
		super.doLayout()
		
		applyCorner()
		applyBorder()
//		applyShadow()
	}
	
}

