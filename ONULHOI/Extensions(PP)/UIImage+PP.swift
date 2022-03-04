//
//  UIImage+PP.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 15..
//  Copyright © 2017년 pplus. All rights reserved.
//

import UIKit

extension UIImage {
	
	enum DefaultImageType {
		case user
		case image
	}
	
	class func defaultImage(_ type: DefaultImageType) -> UIImage? {
		switch type {
		case .user:
			return UIImage(named: "")
		case .image:
			return UIImage(named: "no_image_thumb")
		}
	}
	
}
