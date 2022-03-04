//
//  Date+PP.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 15..
//  Copyright © 2017년 pplus. All rights reserved.
//

import Foundation

// MARK: - To String

extension Date {
	
	/// Format 타입
	///
	/// - date: "yyyy.MM.dd(EEE)"
	/// - time: "a hh:mm"
	/// - dateAndTime: "yyyy.MM.dd(EEE) a hh:mm"
	enum FormatType {
		case date
		case time
		case dateAndTime
		case localizedyyyyMMddhhmm
        case localizedyyyyMMdd
	}
	
	func string(fmt: String) -> String {
		let formatter = DateFormatter()
		if let currentLanguage = Locale.preferredLanguages.first {
			formatter.locale = Locale(identifier: currentLanguage)
		}
		formatter.dateFormat = fmt
		return formatter.string(from: self)
	}
	
	func string(type: FormatType) -> String {
		switch type {
		case .date:
			return string(fmt: "yyyy.MM.dd")
		case .time:
			return string(fmt: "HH:mm")
		case .dateAndTime:
			return string(fmt: "yyyy.MM.dd HH:mm")
		case .localizedyyyyMMddhhmm:
			return string(fmt: HSTR("comm.localized.yyyyMMddHHmm"))
        case .localizedyyyyMMdd:
            return string(fmt: HSTR("comm.localized.yyyyMMdd"))
		}
	}
}

