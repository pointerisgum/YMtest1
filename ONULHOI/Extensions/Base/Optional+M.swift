//
//  Optional+M.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 5..
//  Copyright © 2017년 Mac. All rights reserved.
//

import Foundation

extension Optional {
	
	func unwrapped(or defaultValue: Wrapped) -> Wrapped {
		switch self {
		case .none:
			return defaultValue
		case .some(let originValue):
			return originValue
		}
		//return self ?? defaultValue
	}
	
	func run(_ block:(Wrapped) -> Void) {
		_ = map(block)
	}
	
}
