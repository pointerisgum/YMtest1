//
//  UIImage+M.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 15..
//  Copyright © 2017년 pplus. All rights reserved.
//

import UIKit

extension UIImage {
	
	convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1), scale: CGFloat = UIScreen.main.scale) {
		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		self.init(cgImage: image!.cgImage!)
	}
	
	func withTintColor(_ tintColor: UIColor) -> UIImage? {
		let image = withRenderingMode(.alwaysTemplate)
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		tintColor.set()
		image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}
	
}

extension UIImage {
	
	func resizeForTransparentSpaceAround(newSize: CGSize) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
		
		if let cxt = UIGraphicsGetCurrentContext() {
			UIGraphicsPushContext(cxt)
			draw(at: CGPoint(x: (newSize.width - size.width)/2, y: (newSize.height - size.height)/2))
			UIGraphicsPopContext()
		}
		
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage
	}
	
}

