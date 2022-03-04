//
//  NSLayoutConstraint+M.swift
//  Lulla
//
//  Created by Mac on 2018. 2. 23..
//  Copyright © 2018년 pplus. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
	
	@discardableResult func set(isActive: Bool, priority: Float) -> NSLayoutConstraint {
		self.priority = UILayoutPriority(rawValue: priority)
		self.isActive = isActive
		return self
	}
	
	@discardableResult func changed(multiplier: CGFloat) -> NSLayoutConstraint {
		guard let firstItem = firstItem else { return self }
		
		let newValue = NSLayoutConstraint(item: firstItem, attribute: firstAttribute, relatedBy: relation, toItem: secondItem, attribute: secondAttribute, multiplier: multiplier, constant: constant)
		newValue.priority = priority
		newValue.shouldBeArchived = shouldBeArchived
		newValue.identifier = identifier
		
		NSLayoutConstraint.deactivate([self])
		NSLayoutConstraint.activate([newValue])
		
		return newValue
	}
	
}

