//
//  NARow.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 5..
//  Copyright © 2017년 pplus. All rights reserved.
//

import Foundation

class NARow<T: JSONDecodable>: NABase {
    
    var row: T?
    
    required init(value: Any?) {
        super.init(value: value)
        
//        if let rowJson = json["row"] as? JSON {
//            row = T(json: rowJson)
//        } else if let rowJsons = json["rows"] as? [JSON] {
//            row = T(json: rowJsons.first)
//        }
        
        row = T(json: json)
        
//        if let rowJson = json as? JSON {
//            row = T(json: rowJson)
//        } else if let rowJsons = json["datas"] as? [JSON] {
//            row = T(json: rowJsons.first)
//        }
//        else if let rowJson = json["datas"] as? JSON {
//            row = T(json: rowJson)
//        }
    }
    
}
