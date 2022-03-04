//
//  String+PP.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 19..
//  Copyright © 2017년 pplus. All rights reserved.
//

import Foundation

extension String {
	
	enum FormatType {
		case phone
	}
	
	private func split(source: String, lengths: [Int]) -> [String] {
		var texts: [String] = []
		
		var sIndex: Int = 0
		lengths.forEach {
			let eIndex = sIndex + $0
			if let text = source[safe: sIndex..<eIndex] {
				texts.append(text)
			}
			
			sIndex += $0
		}
		
		return texts
	}
	
	func string(type: FormatType) -> String {
		let regEx = "^0(?:2)(?:\\d{2}|\\d{3,4})\\d{4}$"
		
		let text = replacingOccurrences(of: "+82", with: "0").replacingOccurrences(of: "-", with: "")
		
		let strings: [String] = {
			switch type {
			case .phone:
				switch text.count {
				case 6:
					return split(source: text, lengths: [3, 3])
				case 7:
					return split(source: text, lengths: [3, 4])
				case 8:
					return split(source: text, lengths: [4, 4])
				case 9:
					if NSPredicate(format:"SELF MATCHES %@", regEx).evaluate(with: text) {
						return split(source: text, lengths: [2, 3, 4])
					} else {
						return split(source: text, lengths: [3, 3, 3])
					}
				case 10:
					if NSPredicate(format:"SELF MATCHES %@", regEx).evaluate(with: text) {
						return split(source: text, lengths: [2, 4, 4])
					} else {
						return split(source: text, lengths: [3, 3, 4])
					}
				case 11:
					return split(source: text, lengths: [3, 4, 4])
				case 12:
					return split(source: text, lengths: [3, 3, 3, 3])
				default:
					return [text]
				}
			}
		}()
		
		return strings.joined(separator: "-")
	}
	
}

extension String {
	
	func isGreaterVersion(version: String?) -> Bool {
		guard let version = version else { return true }
		
		let curs = self.split(separator: ".").compactMap { Int($0) }
		let lasts = version.split(separator: ".").compactMap { Int($0) }
		
		var isGreater = true
		
		for index in (0..<min(curs.count, lasts.count)) {
			if curs[index] > lasts[index] {
				isGreater = true
				break
			} else if curs[index] < lasts[index] {
				isGreater = false
				break
			}
		}
		
		if isGreater {
			if lasts.count > curs.count {
				isGreater = false
			}
		}
		
		return isGreater
	}
	
	func isYoutube() -> Bool {
		guard count > 0 else {
			return false
		}
		
		let regEx = "^(https?\\:\\/\\/)?(www\\.youtube\\.com|youtu\\.?be)\\/.+$"
		
		return NSPredicate(format:"SELF MATCHES %@", regEx).evaluate(with: self)
	}
	
	var isValidUrl: Bool {
		return URL(string: self) != nil
	}
	
}

extension String {
	
	enum ImageURLType {
		case none
		case page
		case goods
	}
	
	func imageURLString(type: ImageURLType = .none) -> String? {
		switch type {
		case .none, .page, .goods: return "\(PPCST.Rest.baseURL)/store/api/attachment/image?id=\(self)"
		}
	}
	
    enum StringFormat {
        case image
        case video
        case unowned
    }
    
    func format() -> StringFormat {
        print(self)
        let imageFormats = ["JPEG", "JFIF", "JPEG", "PNG", "HEIC", "BPG", "TIFF", "GIF", "BMP", "JPG"]
        if imageFormats.filter({ self.uppercased().hasSuffix($0) }).count > 0 { return .image }
        
        let videoFormats = ["MP4", "MOV", "WMV", "AVI", "AVCHD", "FLV", "F4V", "SWF", "MKV", "WEBM", "HTML5", "MPEG-2"]
        if videoFormats.filter({ self.uppercased().hasSuffix($0) }).count > 0 { return .video }

        return .unowned
    }
}
