//
//  Date+M.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 15..
//  Copyright © 2017년 pplus. All rights reserved.
//

import Foundation

extension Int {
	
	var era: DateComponents {
		return DateComponents(era: self)
	}
	var year: DateComponents {
		return DateComponents(year: self)
	}
	var month: DateComponents {
		return DateComponents(month: self)
	}
	var day: DateComponents {
		return DateComponents(day: self)
	}
	var hour: DateComponents {
		return DateComponents(hour: self)
	}
	var minute: DateComponents {
		return DateComponents(minute: self)
	}
	var second: DateComponents {
		return DateComponents(second: self)
	}
	var nanosecond: DateComponents {
		return DateComponents(nanosecond: self)
	}
	var weekday: DateComponents {
		return DateComponents(weekday: self)
	}
	var weekdayOrdinal: DateComponents {
		return DateComponents(weekdayOrdinal: self)
	}
	var quarter: DateComponents {
		return DateComponents(quarter: self)
	}
	var weekOfMonth: DateComponents {
		return DateComponents(weekOfMonth: self)
	}
	var weekOfYear: DateComponents {
		return DateComponents(weekOfYear: self)
	}
	var yearForWeekOfYear: DateComponents {
		return DateComponents(yearForWeekOfYear: self)
	}
	
}

// MARK: - Int Extension

extension Date {
	
	var isToday: Bool {
		return Calendar.autoupdatingCurrent.isDateInToday(self)
	}
	
	var isYesterday: Bool {
		return Calendar.autoupdatingCurrent.isDateInYesterday(self)
	}
	
	var isTomorrow: Bool {
		return Calendar.autoupdatingCurrent.isDateInTomorrow(self)
	}
	
	var isWeekend: Bool {
		return Calendar.autoupdatingCurrent.isDateInWeekend(self)
	}
	
}

extension Calendar.Component {
	static var allValues: Set<Calendar.Component> {
		return [.era, .year, .month, .day, .hour, .minute, .second,
				.weekday, .weekdayOrdinal, .quarter,
				.weekOfMonth, .weekOfYear, .yearForWeekOfYear,
				.nanosecond, .calendar, .timeZone]
	}
}

extension Date {
	
	var components: DateComponents {
		return Calendar.autoupdatingCurrent.dateComponents(Calendar.Component.allValues, from: self)
	}
	
	var era: Int {
		return self.components.era ?? 0
	}
	var year: Int {
		return self.components.year ?? 0
	}
	var month: Int {
		return self.components.month ?? 0
	}
	var day: Int {
		return self.components.day ?? 0
	}
	var hour: Int {
		return self.components.hour ?? 0
	}
	var minute: Int {
		return self.components.minute ?? 0
	}
	var second: Int {
		return self.components.second ?? 0
	}
	var nanosecond: Int {
		return self.components.nanosecond ?? 0
	}
	var weekday: Int {
		return self.components.weekday ?? 0
	}
	var weekdayOrdinal: Int {
		return self.components.weekdayOrdinal ?? 0
	}
	var quarter: Int {
		return self.components.quarter ?? 0
	}
	var weekOfMonth: Int {
		return self.components.weekOfMonth ?? 0
	}
	var weekOfYear: Int {
		return self.components.weekOfYear ?? 0
	}
	var yearForWeekOfYear: Int {
		return self.components.yearForWeekOfYear ?? 0
	}
	
    func getAgoTime() -> String {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else { return "" }

        var secondsAgo = Int(localDate.timeIntervalSince(self))
        if secondsAgo < 0 {
            secondsAgo = secondsAgo * (-1)
        }
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day

        if secondsAgo < minute  {
            if secondsAgo < 2{
                return HSTR("지금")
            } else {
                return String(format: "%ld%@", secondsAgo, HSTR("초 전"))
            }
        } else if secondsAgo < hour {
            let min = secondsAgo/minute
            return String(format: "%ld%@", min, HSTR("분 전"))
        } else if secondsAgo < day {
            let hr = secondsAgo/hour
            return String(format: "%ld%@", hr, HSTR("시간 전"))
        } else if secondsAgo < week {
            let day = secondsAgo/day
            return String(format: "%ld%@", day, HSTR("일 전"))
        } else {
            if self.year < Date().year {
                //이전 해의 게시물
                return String(format: "%04ld%@ %02ld%@ %02ld%@" , self.year, HSTR("년"), self.month, HSTR("월"), self.day, HSTR("일"))
            } else {
                //올해의 게시물
                return String(format: "%02ld%@ %02ld%@" , self.month, HSTR("월"), self.day, HSTR("일"))
            }
        }
    }
    
    func getDday(toDate: Date) -> Int? {
        let components = Calendar.current.dateComponents([.day], from: Date(), to: toDate)
        return components.day
    }

    func getDhour(toDate: Date) -> Int? {
        let components = Calendar.current.dateComponents([.hour], from: Date(), to: toDate)
        return components.hour
    }

    func getDminute(toDate: Date) -> Int? {
        let components = Calendar.current.dateComponents([.minute], from: Date(), to: toDate)
        return components.minute
    }

    func getFullTime() -> String {
        //1617716528699
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        print("All Components : \(components)")
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        var hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        
        var separate = HSTR("오전")
        if hour > 12 {
            hour -= 12
            separate = HSTR("오후")
        }
        return String(format: "%04ld.%02ld.%02ld %@ %02ld:%02ld", year, month, day, separate, hour, minutes)
    }
    
    func getSurveyTime() -> String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
//        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        return String(format: "%04ld.%02ld.%02ld %@", year, month, day, HSTR("오후 12시"))
    }

    func getWeakDay() -> String {
        switch self.weekday {
        case 1: return HSTR("일")
        case 2: return HSTR("월")
        case 3: return HSTR("화")
        case 4: return HSTR("수")
        case 5: return HSTR("목")
        case 6: return HSTR("금")
        case 7: return HSTR("토")
        default:
            return ""
        }
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

extension Date {
    
    func set(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        let componenets: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        var dateComponents =  Calendar.current.dateComponents(componenets, from: self)
        
        if let year = year {
            dateComponents.year = year
        }
        if let month = month {
            dateComponents.month = month
        }
        if let day = day {
            dateComponents.day = day
        }
        if let hour = hour {
            dateComponents.hour = hour
        }
        if let minute = minute {
            dateComponents.minute = minute
        }
        if let second = second {
            dateComponents.second = second
        }
        
        return Calendar.current.date(from: dateComponents) ?? self
    }
    
}

extension DateComponents {
	
	private static func combine(_ lhs: Int? = nil, _ rhs: Int? = nil) -> Int {
		return (lhs ?? 0) + (rhs ?? 0)
	}
	
	static prefix func - (rhs: DateComponents) -> DateComponents {
		return DateComponents(
			year: -combine(rhs.year), month: -combine(rhs.month), day: -combine(rhs.day),
			hour: -combine(rhs.hour), minute: -combine(rhs.minute), second: -combine(rhs.second),
			nanosecond: -combine(rhs.nanosecond)
		)
	}
	
	static func + (lhs: DateComponents, rhs: DateComponents) -> DateComponents {
		return DateComponents(
			year: combine(lhs.year, rhs.year), month: combine(lhs.month, rhs.month), day: combine(lhs.day, rhs.day),
			hour: combine(lhs.hour, rhs.hour), minute: combine(lhs.minute, rhs.minute), second: combine(lhs.second, rhs.second),
			nanosecond: combine(lhs.nanosecond, rhs.nanosecond)
		)
	}
	
	static func - (lhs: DateComponents, rhs: DateComponents) -> DateComponents {
		return lhs + (-rhs)
	}
	
}

extension Date {
	
	static func + (lhs: Date, rhs: DateComponents) -> Date {
		return Calendar.current.date(byAdding: rhs, to: lhs) ?? lhs
	}
	
	static func - (lhs: Date, rhs: DateComponents) -> Date {
		return Calendar.current.date(byAdding: -rhs, to: lhs) ?? lhs
	}
	
}

extension Date {
	
	func differenceDays(from date: Date) -> Int {
		let toDate = Calendar.current.startOfDay(for: self)
		let fromDate = Calendar.current.startOfDay(for: date)
		
		guard let day = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day else {
			return 0
		}
		
		return day
	}
	
}
