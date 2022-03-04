//
//  IIBBorder.swift
//  Lulla
//
//  Created by Mac on 2018. 1. 30..
//  Copyright © 2018년 pplus. All rights reserved.
//

import UIKit

protocol IIBBorder {
	var borderColor: UIColor { get set }
	var borderWidth: CGFloat { get set }
}

extension IIBBorder where Self: UIView {
	
	func applyBorder() {
		layer.borderColor = borderColor.cgColor
		layer.borderWidth = borderWidth
	}
	
}
