//
//  NEStatus.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 5..
//  Copyright © 2017년 pplus. All rights reserved.
//

import Foundation

enum NEStatus: String, JSONCodable {
	case active
	case expire
	case delete
}

extension NEStatus: EnumDefaultValue {
	static var defaultValue: NEStatus {
		return .active
	}
}
