//
//  Animations.swift
//  Lulla
//
//  Created by Mac on 2018. 9. 14..
//  Copyright © 2018년 pplus. All rights reserved.
//

import UIKit

extension UIImageView {
	
	enum AnimationType {
		case scale(x: CGFloat, y: CGFloat)
	}
	
	func animate(type: AnimationType) {
		switch type {
		case .scale(let x, let y):
			let iv = UIImageView(frame: frame)
			iv.image = image
			superview?.addSubview(iv)
			UIView.animate(withDuration: 0.25, animations: {
				iv.transform = CGAffineTransform(scaleX: x, y: y)
				iv.alpha = 0
			}, completion: { finished in
				iv.removeFromSuperview()
			})
		}
	}
	
}
