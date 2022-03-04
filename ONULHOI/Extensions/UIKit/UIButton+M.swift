//
//  UIButton+M.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 1..
//  Copyright © 2017년 Mac. All rights reserved.
//

import UIKit

extension UIButton {
	
	/// 노멀 상태 title
	var text: String? {
		get {
			return title(for: .normal)
		}
		set {
			setTitle(newValue, for: .normal)
		}
	}
	
	/// 노멀 상태 attributedTitle
	var attributedText: NSAttributedString? {
		get {
			return attributedTitle(for: .normal)
		}
		set {
			setAttributedTitle(newValue, for: .normal)
		}
	}
	
	/// 노멀 상태 image
	var image: UIImage? {
		get {
			return image(for: .normal)
		}
		set {
			setImage(newValue, for: .normal)
		}
	}
	
	/// 노멀 상태 backgroundImage
	var backgroundImage: UIImage? {
		get {
			return backgroundImage(for: .normal)
		}
		set {
			setBackgroundImage(newValue, for: .normal)
		}
	}
	
	/// 노멀 상태 titleColor
	var textColor: UIColor? {
		get {
			return titleColor(for: .normal)
		}
		set {
			setTitleColor(newValue, for: .normal)
		}
	}
	
}

extension UIButton {
	
	func setUnderlineText(_ underlineText: String?, for state: UIControl.State) {
		guard let underlineText = underlineText, let font = titleLabel?.font, let textColor = textColor else {
			setAttributedTitle(nil, for: state)
			return
		}
		
		let newAttributedText = { () -> NSMutableAttributedString in
			let attributedText = NSMutableAttributedString()
			attributedText.append(NSAttributedString(
				string: underlineText,
				attributes: [.font: font, .foregroundColor: textColor, .underlineStyle: NSUnderlineStyle.single.rawValue])
			)
			
			return attributedText
		}()
		
		setAttributedTitle(newAttributedText, for: state)
	}
	
	func underlineText(for state: UIControl.State) -> String? {
		return attributedTitle(for: state)?.string
	}
	
	var underlineText: String? {
		get {
			return underlineText(for: .normal)
		}
		set {
			setUnderlineText(newValue, for: .normal)
		}
	}
	
	func applyHighlight(_ hltText: String?, color: UIColor?) {
		guard let hltText = hltText, hltText.count > 0, let color = color else { return }
		guard let fullText = text, let font = titleLabel?.font, let textColor = textColor else { return }
		
		attributedText = {
			let attributedText = NSMutableAttributedString(
				string: fullText,
				attributes: [.font: font, .foregroundColor: textColor]
			)
			
			attributedText.addAttributes([.foregroundColor: color], highlightText: hltText)
			
			return attributedText
		}()
	}
	
}

extension UIButton {
	
	func applyToggleStyle() {
		setTitle(title(for: .normal), for: [.normal, .highlighted])
		setTitle(title(for: .selected), for: [.selected, .highlighted])
		
		setAttributedTitle(attributedTitle(for: .normal), for: [.normal, .highlighted])
		setAttributedTitle(attributedTitle(for: .selected), for: [.selected, .highlighted])
		
		setTitleColor(titleColor(for: .normal), for: [.normal, .highlighted])
		setTitleColor(titleColor(for: .selected), for: [.selected, .highlighted])
		
		setImage(image(for: .normal), for: [.normal, .highlighted])
		setImage(image(for: .selected), for: [.selected, .highlighted])
		
		setBackgroundImage(backgroundImage(for: .normal), for: [.normal, .highlighted])
		setBackgroundImage(backgroundImage(for: .selected), for: [.selected, .highlighted])
	}
	
	func adjustsVerticalCenter(spaceH: CGFloat) {
		guard let font = titleLabel?.font
			, let titleSize = title(for: .normal)?.size(withAttributes: [.font: font])
			, let imageSize = image(for: .normal)?.size else { return }
		
		titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spaceH), right: 0)
		imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spaceH), left: 0, bottom: 0, right: -titleSize.width)
	}
	
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
