//
//  UIStackView+PP.swift
//  Lulla
//
//  Created by Mac on 2018. 10. 4..
//  Copyright © 2018년 pplus. All rights reserved.
//

import UIKit

extension UIStackView {
	
	func removeAllArrangedSubview() {
		arrangedSubviews.forEach {
			removeArrangedSubview($0)
			$0.removeFromSuperview()
		}
	}
	
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach({
            addArrangedSubview($0)
        })
    }
	
	func addLabels(text: String, separatedBy: String, font: UIFont, textColor: UIColor) {
		UIView().removeFromSuperview()
		arrangedSubviews.forEach {
			removeArrangedSubview($0)
			$0.removeFromSuperview()
		}
		text.components(separatedBy: separatedBy).forEach {
			let label = UILabel()
			label.numberOfLines = 0
			label.font = font
			label.textColor = textColor
			label.text = $0
			addArrangedSubview(label)
		}
	}
	
}
