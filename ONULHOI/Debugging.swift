//
//  Debugging.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 1..
//  Copyright © 2017년 Mac. All rights reserved.
//

import Foundation

extension Bool {
	func debugFlag() -> Bool {
		#if DEBUG
			return self
		#else
			return false
		#endif
	}
}

let MTrue = true.debugFlag()
let MFalse = false.debugFlag()

struct __DD__ {
	
	struct UI {
		static let drawLineEnable = MTrue
	}
	
	struct LOG {
		static let HM = MTrue
		
		static let NET = MTrue
		static let NET_Response_Show = MTrue
		static let NET_RequestHeader_Show = MTrue
		
		static let WEB = MFalse
		
		static let PUSH = MTrue
		
		static let AdBrix = MFalse
	}
	
	struct Login {
		static let enable = MTrue
//        static let id = "nacker7"
//        static let pwd = "1111"
//        static let id = "kimjk"
//        static let pwd = "1111"
        static let id = "qufdhkd1"    //당첨 이력이 있는 계정
//        static let pwd = "1111"
//        static let id = "bayaba1977"
//        static let pwd = "5412"
//        static let id = "qorelddy"
//        static let id = "y002"
        static let pwd = "1111"
	}
	
	struct Purchase {
		static let enable = MFalse
	}
    
}

func LogS(_ prefix: String,_ items: Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
	#if DEBUG
		Swift.print("\(prefix)\(items)")
	#endif
}

func LogD(_ prefix: String,_ items: Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
	#if DEBUG
		Swift.print("\(prefix) \(function):(\(line)) \(items)")
	#endif
}

func HMLog(_ items: Any, file:String = #file, function:String = #function, line:(Int)=#line) {
	guard __DD__.LOG.HM else { return }
	LogD("[HM]", items, file, function, line)
}

func NETLog(_ items: Any, file:String = #file, function:String = #function, line:(Int)=#line) {
	guard __DD__.LOG.NET else { return }
	LogS("[NET]", items, file, function, line)
}

func WEBLog(_ items: Any, file:String = #file, function:String = #function, line:(Int)=#line) {
	guard __DD__.LOG.WEB else { return }
	LogD("[WEB]", items, file, function, line)
}

func PUSHLog(_ items: Any, file:String = #file, function:String = #function, line:(Int)=#line) {
	guard __DD__.LOG.PUSH else { return }
	LogD("[PUSH]", items, file, function, line)
}

func AdBrixLog(_ items: Any, file:String = #file, function:String = #function, line:(Int)=#line) {
	guard __DD__.LOG.AdBrix else { return }
	LogS("[AdBrix]", items, file, function, line)
}





