//
//  NAGet.swift
//  Lulla
//
//  Created by Mac on 2018. 10. 10..
//  Copyright © 2018년 pplus. All rights reserved.
//

import Foundation

// MARK: - NAGet

final class NAGet<T: JSONDecodable>: NABase {
	
	var row: Row<T>?
	
	required init(value: Any?) {
		super.init(value: value)
		
		row = Row<T>(json: json["data"] as? JSON)
	}
	
}

extension NAGet {
	
	final class Row<T: JSONDecodable>: JSONDecodable {
		var totalPages: Int?
		var totalElements: Int?
		var last: Bool?
		var first: Bool?
		
		var sort: Sort?
		var size: Int?
		var number: Int?
		var numberOfElements: Int?
		
		var content: [T]?
	}
	
	final class Sort: JSONCodable {
		var sorted: Bool?
		var unsorted: Bool?
	}
	
	final class Pageable: JSONCodable {
		var pageSize: Int?
		var pageNumber: Int?
		var offset: Int?
		var unpaged: Bool?
		var paged: Bool?
	}
	
}

