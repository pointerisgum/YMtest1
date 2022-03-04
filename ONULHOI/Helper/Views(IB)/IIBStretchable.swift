//
//  IIBStretchable.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 22..
//  Copyright © 2017년 pplus. All rights reserved.
//

import UIKit

extension UIImage {
	
	func stretchableImage(_ point: CGPoint = .zero) -> UIImage {
		let applyPoint = point == .zero ? CGPoint(x: self.size.width/2, y: self.size.height/2) : point
		let leftCap = Int(applyPoint.x)
		let topCap = Int(applyPoint.y)
		
		return self.stretchableImage(withLeftCapWidth: leftCap,topCapHeight: topCap)
	}
	
}

protocol IIBStretchable {
	var stretchableEnable: Bool { get set }
	var stretchablePoint: CGPoint { get set }
}


extension IIBStretchable {
	
	func stretchableImage(_ image: UIImage?, point: CGPoint) -> UIImage? {
		guard let image = image else {
			return nil
		}
		
		return image.stretchableImage(point)
	}
	
}

extension IIBStretchable where Self: UIImageView {
	
	func applyStretchable() {
		self.image = stretchableImage(self.image, point: stretchablePoint)
		self.highlightedImage = stretchableImage(self.highlightedImage, point: stretchablePoint)
	}
	
}

extension IIBStretchable where Self: UIButton {
	
	func applyStretchable() {
		guard self.stretchableEnable else { return }
		
		self.setBackgroundImage(stretchableImage(self.backgroundImage(for: .normal), point: stretchablePoint), for: .normal)
		self.setBackgroundImage(stretchableImage(self.backgroundImage(for: .highlighted), point: stretchablePoint), for: .highlighted)
		self.setBackgroundImage(stretchableImage(self.backgroundImage(for: .disabled), point: stretchablePoint), for: .disabled)
		self.setBackgroundImage(stretchableImage(self.backgroundImage(for: .selected), point: stretchablePoint), for: .selected)
		self.setBackgroundImage(stretchableImage(self.backgroundImage(for: .highlighted), point: stretchablePoint), for: .highlighted)
		self.setBackgroundImage(stretchableImage(self.backgroundImage(for: [.selected, .highlighted]), point: stretchablePoint), for: [.selected, .highlighted])
	}
	
}
