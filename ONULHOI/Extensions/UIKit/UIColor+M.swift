//
//  UIColor+M.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 8..
//  Copyright © 2017년 pplus. All rights reserved.
//

import UIKit

extension UIColor {
	
	class func hexColor(_ hex: Int, alpha: Float = 1.0) -> UIColor! {
		return UIColor(hex: hex, alpha: alpha)
	}
	
	class func hexStringColor(_ hexString: String, alpha: Float = 1.0) -> UIColor! {
		return UIColor(hexString: hexString, alpha: alpha)
	}
	
	public convenience init(hex: Int, alpha: Float = 1.0) {
		self.init(red: CGFloat((hex & 0xFF0000) >> 16)/255.0, green: CGFloat((hex & 0xFF00) >> 8)/255.0, blue: CGFloat(hex & 0xFF)/255.0, alpha: CGFloat(alpha))
	}
	
	public convenience init(hexString: String, alpha: Float = 1.0) {
		guard hexString.count == 7 else {
			self.init(hex: 0xffffff, alpha: alpha)
			return
		}
		
		var rgbValue: UInt32 = 0
		
		let scanner = Scanner(string: hexString)
		scanner.scanLocation = 1 // bypass '#'
		scanner.scanHexInt32(&rgbValue)
		
		self.init(hex: Int(rgbValue), alpha: alpha)
	}
	
}

extension UIColor {
    
    var hex: Int {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return Int(red*255)<<16 | Int(green*255)<<8 | Int(blue*255)<<0
    }
    
}


extension UIColor {

  @nonobjc class var mainColor: UIColor {
    return UIColor.hexColor(0x18a0fb)
//    return UIColor(red: 115.0 / 255.0, green: 205.0 / 255.0, blue: 192.0 / 255.0, alpha: 1.0)
  }
}
