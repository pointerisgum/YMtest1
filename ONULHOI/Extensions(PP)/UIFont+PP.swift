//
//  UIFont+PP.swift
//  Lulla
//
//  Created by Mac on 2018. 9. 4..
//  Copyright © 2018년 pplus. All rights reserved.
//

import UIKit

extension UIFont {
	
	enum Kind { case number }
	enum Style { case regular, bold, italic, boldItalic }
	
	class func font(kind: Kind, style: Style, fontSize: CGFloat) -> UIFont {
		switch kind {
		case .number:
			switch style {
			case .regular:
				return UIFont(name: "TrebuchetMS", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: .regular)
			case .bold:
				return UIFont(name: "TrebuchetMS-Bold", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: .bold)
			case .italic:
				return UIFont(name: "TrebuchetMS-Italic", size: fontSize) ?? .italicSystemFont(ofSize: fontSize)
			case .boldItalic:
				return UIFont(name: "TrebuchetMS-BoldItalic", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: .bold)
			}
		}
	}
	
}
