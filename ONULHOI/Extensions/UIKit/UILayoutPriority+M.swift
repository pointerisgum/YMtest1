//
//  UILayoutPriority+M.swift
//  Lulla
//
//  Created by Mac on 2018. 2. 23..
//  Copyright © 2018년 pplus. All rights reserved.
//

import UIKit

extension UILayoutPriority {
	
	static func + (lhs: UILayoutPriority, rhs: Float) -> UILayoutPriority {
		return UILayoutPriority(rawValue: lhs.rawValue + rhs)
	}
	
	static func - (lhs: UILayoutPriority, rhs: Float) -> UILayoutPriority {
		return UILayoutPriority(rawValue: lhs.rawValue - rhs)
	}
	
}
