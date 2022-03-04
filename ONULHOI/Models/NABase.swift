//
//  NABase.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 5..
//  Copyright © 2017년 Mac. All rights reserved.
//

import Foundation

class NABase {
	
	var json: JSON = [:]
	
	var resultCode: Int = 0
    var resultString: String?
	var appResultMessage: String?
    var token: String?

	var isSuccessed: Bool {
		return resultCode == 200
	}
	
	required init(value: Any?) {
		if let json = value as? JSON {
			self.json = json
			self.resultCode = (json["resultCode"] as? Int).unwrapped(or: 0)
            self.resultString = json["success"] as? String
			self.appResultMessage = json["message"] as? String
            self.token = json["token"] as? String
		}
	}
}
