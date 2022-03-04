//
//  String+M.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 5..
//  Copyright © 2017년 pplus. All rights reserved.
//

import UIKit

extension String {
	
	func trimmed() -> String {
		return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
	}
	
	func toNSNumber() -> NSNumber? {
		return NumberFormatter().number(from: self)
	}
	
	func toFloat() -> Float? {
		return toNSNumber()?.floatValue
	}
	
	func toCGFloat() -> CGFloat? {
		if let number = toNSNumber() {
			return CGFloat(truncating: number)
		}
		return nil
	}
	
	func toInt() -> Int? {
		return self.toNSNumber()?.intValue
	}
	
	func toInt64() -> Int64? {
		return self.toNSNumber()?.int64Value
	}
	
	func toDouble() -> Double? {
		return toNSNumber()?.doubleValue
	}
	
	func toBool() -> Bool {
		let trimmed = self.trimmed().lowercased()
		return (trimmed as NSString).boolValue
	}
	
	func toDecimalString() -> String {
		if let number = self.toNSNumber() {
			let formatter = NumberFormatter()
			formatter.numberStyle = .decimal
			return formatter.string(from: number) ?? ""
		}
		return ""
	}
	
	func toDate(fmt: String) -> Date? {
		let formatter = DateFormatter()
		formatter.dateFormat = fmt
//        formatter.timeZone = TimeZone(abbreviation: "UTC")
		return formatter.date(from: self)
	}
	
    func toDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: dateString)
    }

	func toJson() -> JSON? {
		if let data = data(using: .utf8) {
			do {
				return try JSONSerialization.jsonObject(with: data, options: []) as? JSON
			} catch {
				print("--->error.localizedDescription: \(error.localizedDescription)")
				return nil
			}
		}
		
		return nil
	}
	
}

extension String {
	
	func split(by string: String) -> [String] {
		#if swift(>=4)
			return self.trimmingCharacters(in: .whitespaces).split(separator: Character(string)).map {String($0)}
		#else
			return self.trimmingCharacters(in: .whitespaces).components(separatedBy: string)
		#endif
	}
	
	func addLeftPad(with pad: String, length: Int) -> String {
		guard length > count else { return self }
		
		return String(repeating: pad, count: length - count) + self
	}

    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
}

extension String {
	
	subscript(safe i: Int) -> String? {
		guard i >= 0 && i < count else {
			return nil
		}
		return String(self[index(startIndex, offsetBy: i)])
	}
	
	subscript(safe range: CountableRange<Int>) -> String? {
		guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else {
			return nil
		}
		guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else {
			return nil
		}
		return String(self[lowerIndex..<upperIndex])
	}
	
	subscript(safe range: ClosedRange<Int>) -> String? {
		guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else {
			return nil
		}
		guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) else {
			return nil
		}
		
		return String(self[lowerIndex..<upperIndex])
	}
	
}

extension String {
	
	subscript(value: PartialRangeUpTo<Int>) -> Substring {
		get {
			return self[..<index(startIndex, offsetBy: value.upperBound)]
		}
	}
	
	subscript(value: PartialRangeThrough<Int>) -> Substring {
		get {
			return self[...index(startIndex, offsetBy: value.upperBound)]
		}
	}
	
	subscript(value: PartialRangeFrom<Int>) -> Substring {
		get {
			return self[index(startIndex, offsetBy: value.lowerBound)...]
		}
	}
	
}

extension String {
	
	var isNumeric: Bool {
		return isEmpty == false && (rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil)
	}
    
    var isExist: Bool {
        return (trimmed().count > 0)
    }
	
    func pathExtension() -> String {
        return (self as NSString).pathExtension
    }
    
    func convertStringToDictionary() -> [String:AnyObject]? {
       if let data = self.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
   }
}
