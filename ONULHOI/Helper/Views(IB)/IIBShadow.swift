//
//  IIBShadow.swift
//  Lulla
//
//  Created by Mac on 2018. 1. 30..
//  Copyright © 2018년 pplus. All rights reserved.
//

import UIKit

private class ShadowLayer: CALayer {}

protocol IIBShadow {
	var shadowColor: UIColor { get set }
	var shadowBlur: CGFloat { get set }
	var shadowOffset: CGSize { get set }
}

extension IIBShadow where Self: UIView {
	
	func applyShadow() {
        clipsToBounds = false
        
		layer.shadowColor = shadowColor.cgColor
		layer.shadowRadius = shadowBlur
		layer.shadowOffset = shadowOffset

		layer.shadowOpacity = 1
		layer.masksToBounds = false
	}
	
}

