//
//  Double+M.swift
//  Lulla
//
//  Created by Mac on 2018. 10. 4..
//  Copyright © 2018년 pplus. All rights reserved.
//

import Foundation

extension Double {
    
    func toString() -> String {
        return String(self)
    }
    
    func roundTo(place: Int) -> Double {
        let divisor = pow(10.0, Double(1))
        return (self*divisor).rounded()/divisor
    }
    
    func secondsToHoursMinutesSeconds() -> (Int, Int, Int) {
        return (Int(self.rounded()) / 3600, (Int(self.rounded()) % 3600) / 60, (Int(self.rounded()) % 3600) % 60)
    }
    
    func secondsToString() -> String {
        let (h,m,s) = secondsToHoursMinutesSeconds()
        var str: String = ""
        if h > 0 {
            str.append(String(format: "%02d", h))
            str.append(":")
        }
        str.append(String(format: "%02d", m))
        str.append(":")
        str.append(String(format: "%02d", s))
        return str
    }

//    func aabbcc() -> String {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.hour, .minute, .second]
//        formatter.unitsStyle = .short
//        let formattedString = formatter.string(from: TimeInterval(self))!
//        print(formattedString)
//        return formattedString
//    }
}
