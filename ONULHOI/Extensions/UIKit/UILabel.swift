//
//  UILabel.swift
//  Lulla
//
//  Created by Mac on 2018. 4. 5..
//  Copyright © 2018년 pplus. All rights reserved.
//

import UIKit

extension UILabel {
	
	var underlineText: String? {
		get {
			return attributedText?.string
		}
		set {
			guard let underlineText = newValue, let font = font, let textColor = textColor else {
				attributedText = nil
				return
			}
			
			attributedText = {
				let attributedText = NSMutableAttributedString()
				attributedText.append(NSAttributedString(
					string: underlineText,
					attributes: [.font: font, .foregroundColor: textColor, .underlineStyle: NSUnderlineStyle.single.rawValue])
				)
				
				return attributedText
			}()
		}
	}
	
	var strikethroughText: String? {
		get {
			return attributedText?.string
		}
		set {
			guard let strikethroughText = newValue, let font = font, let textColor = textColor else {
				attributedText = nil
				return
			}
			
			attributedText = {
				let attributedText = NSMutableAttributedString()
				attributedText.append(NSAttributedString(
					string: strikethroughText,
					attributes: [.font: font, .foregroundColor: textColor, .strikethroughStyle: NSUnderlineStyle.single.rawValue])
				)
				
				return attributedText
			}()
		}
	}
	
	func applyHighlight(_ hltText: String?, color: UIColor?) {
		guard let hltText = hltText, hltText.count > 0, let color = color else { return }
		guard let fullText = text, let font = font, let textColor = textColor else { return }
		
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


extension UILabel {
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        
        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font as Any])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor, .underlineStyle: NSUnderlineStyle.single.rawValue])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }
    
    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}

extension UILabel {
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font as Any], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }

    var numberOfVisibleLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
    
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font as Any], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }

//    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
//        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
//        label.numberOfLines = 0
//        label.text = self
//        label.font = font
//        label.sizeToFit()
//        return label.frame.height
//     }
    
    func height() -> CGFloat {
        self.sizeToFit()
        return self.frame.height
     }

}
