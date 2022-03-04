//
//  NEPlatform.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 5..
//  Copyright © 2017년 pplus. All rights reserved.
//

import Foundation

/// 가입 플랫폼
///
/// - ios: IOS
/// - aos: 안드로이드
/// - cms: CMS
/// - pcWeb: PC웹
/// - mobileWeb: 모바일웹
/// - system: 관리자 등록
enum NEPlatform: String, JSONCodable {
	case none
	case ios
	case aos
	case cms
	case pcWeb
	case mobileWeb
	case system
}

extension NEPlatform: EnumDefaultValue {
	static var defaultValue: NEPlatform {
		return .none
	}
}

