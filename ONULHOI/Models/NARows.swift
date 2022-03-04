//
//  NARows.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 5..
//  Copyright © 2017년 pplus. All rights reserved.
//

import Foundation

class NARows<T: JSONDecodable>: NABase {
	
	var rows: [T] = []
	
	required init(value: Any?) {
		super.init(value: value)
		
        let rowJson = value as? Array<Any>
        if let rowJson = rowJson {
            rows = rowJson.compactMap {
                T(json: $0 as? JSON)
            }
        }

//		if let rowJsons = json["rows"] as? [JSON] {
//			rows = rowJsons.compactMap { T(json: $0) }
//		} else if let rowJson = json["row"] as? JSON {
//			rows = [T(json: rowJson)].compactMap { $0 }
//		}
//        if let rowJsons = json["datas"] as? [JSON] {
//            rows = rowJsons.compactMap { T(json: $0) }
//        } else if let rowJson = json["data"] as? JSON {
//            rows = [T(json: rowJson)].compactMap { $0 }
//        }
	}
	
}
