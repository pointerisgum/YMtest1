//
//  NEMoveType.swift
//  Lulla
//
//  Created by Mac on 2018. 3. 6..
//  Copyright © 2018년 pplus. All rights reserved.
//

import Foundation

enum NEMoveType: String, JSONCodable, EnumDefaultValue {
	static var defaultValue: NEMoveType = .external
	case external
    case inner
}
