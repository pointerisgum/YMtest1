//
//  Int+PP.swift
//  Lulla
//
//  Created by Mac on 2018. 1. 26..
//  Copyright © 2018년 pplus. All rights reserved.
//

import UIKit

extension Int64 {
	
	enum FormatType {
		case bol, cash, discountCash
		case percent
		case mobileGift, cases
        case eventTicket
        case ea
	}
	
	func demicalString() -> String? {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter.string(from: NSNumber(value: self))
	}
	
	func string(type: FormatType) -> String {
		guard let demical = demicalString() else { return "" }
		
		switch type {
		case .bol: return String(format: HSTR("comm.bol_fmt"), demical)
		case .cash: return String(format: HSTR("comm.cash_fmt"), demical)
		case .discountCash: return String(format: HSTR("comm.discountCash_fmt"), demical)
		case .percent: return String(format: HSTR("comm.percent_fmt"), demical)
		case .mobileGift: return String(format: HSTR("comm.mobileGift_fmt"), demical)
		case .cases: return String(format: HSTR("comm.cases_fmt"), demical)
        case .eventTicket: return String(format: HSTR("comm.event.ticket_fmt"), demical)
        case .ea: return String(format: HSTR("comm.lotto.ticketCount_fmt"), demical)
		}
	}
	
	func attributedText(type: FormatType, font: UIFont?, textColor: UIColor?) -> NSAttributedString {
		//let fullString = string(type: type)
		
		guard let font = font, let textColor = textColor, let demical = demicalString() else { return NSAttributedString(string: "") }
		
		let fullString: String = {
			switch type {
			case .bol: return String(format: HSTR("comm.bol_fmt"), demical)
			case .cash: return String(format: HSTR("comm.cash_fmt"), demical)
			case .discountCash: return String(format: HSTR("comm.discountCash_fmt"), demical)
			case .percent: return String(format: HSTR("comm.percent_fmt"), demical)
			case .mobileGift: return String(format: HSTR("comm.mobileGift_fmt"), demical)
			case .cases: return String(format: HSTR("comm.cases_fmt"), demical)
            case .eventTicket: return String(format: HSTR("comm.event.ticket_fmt"), demical)
            case .ea: return String(format: HSTR("comm.lotto.ticketCount_fmt"), demical)
			}
		}()
		
		let attributedText = NSMutableAttributedString(string: fullString, attributes: [.font: UIFont.systemFont(ofSize: ceil(font.pointSize*0.9), weight: .regular), .foregroundColor: textColor])
		attributedText.addAttributes([.font: UIFont.systemFont(ofSize: font.pointSize, weight: .bold)], highlightText: demical)
		
		return attributedText
	}
	
}
