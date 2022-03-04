//
//  NEAuthType.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 19..
//  Copyright © 2017년 pplus. All rights reserved.
//

import Foundation

/// 인증 종류
///
/// - join: join
/// - profile: profile
/// - findId: findId
/// - findPassword: findPassword
/// - leave: leave
/// - cancelLeave: cancelLeave
enum NEAuthType: String, JSONCodable {
	case join
	case profile
	case findId
	case findPassword
	case changeMobile
	case leave
	case cancelLeave
}
