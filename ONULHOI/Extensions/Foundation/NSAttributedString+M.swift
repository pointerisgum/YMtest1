//
//  NSAttributedString+M.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 21..
//  Copyright © 2017년 pplus. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
	
	func addAttribute(_ name: NSAttributedString.Key, value: Any, highlightText: String) {
		let range: NSRange = (string as NSString).range(of: highlightText)
		addAttribute(name, value: value, range: range)
	}
	
	func addAttributes(_ attrs: [NSAttributedString.Key : Any] = [:], highlightText: String) {
		let range: NSRange = (string as NSString).range(of: highlightText)
		addAttributes(attrs, range: range)
	}
	
	func append(image: UIImage?, bounds: CGRect? = nil) {
		guard let image = image else { return }
		
		let attachment = NSTextAttachment()
		attachment.image = image
		if let bounds = bounds {
			attachment.bounds = bounds
		}
		
		append(NSAttributedString(attachment: attachment))
	}
	
}
