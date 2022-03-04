//
//  IIBCorner.swift
//  Lulla
//
//  Created by Mac on 2018. 1. 30..
//  Copyright © 2018년 pplus. All rights reserved.
//

import UIKit

protocol IIBCorner {
	var cornerRadius: CGFloat { get set }
}

extension IIBCorner where Self: UIView {
	
	func applyCorner() {
		layer.cornerRadius = cornerRadius
        clipsToBounds = true
        layer.masksToBounds = true
//		clipsToBounds = (cornerRadius.isNaN == false && cornerRadius > 0)
	}
	
}
