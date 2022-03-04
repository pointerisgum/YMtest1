//
//  Codable+JSON.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 5..
//  Copyright © 2017년 Mac. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

// MARK: - JSONDecodable

protocol JSONDecodable: Decodable {
	init?(json: JSON?)
}

extension JSONDecodable {
	
	static var dateFormatter: DateFormatter {
		let fmt = DateFormatter()
		fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return fmt
	}
	
	init?(json: JSON?) {
		guard let json = json else { return nil }
		
		do {
			var options: JSONSerialization.WritingOptions = []
			if #available(iOS 11, *) {
				options.insert(.sortedKeys)
			}
			let data = try JSONSerialization.data(withJSONObject: json, options: options)
			
			self.init(data: data)
		} catch  {
			debugPrint("[JSONCodable][init]error: \(error)")
			return nil
		}
	}
	
	init?(data: Data?) {
		guard let data = data else { return nil }
		
		do {
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .formatted(Self.dateFormatter)
			
			let object = try decoder.decode(Self.self, from: data)
			self = object
		} catch  {
			debugPrint("[JSONCodable][init]error: \(error)")
			return nil
		}
	}
	
}

// MARK: - JSONEncodable

protocol JSONEncodable: Encodable {
	func toData() -> Data?
	func toJson() -> JSON?
}

extension JSONEncodable {
	
	static var dateFormatter: DateFormatter {
		let fmt = DateFormatter()
		fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return fmt
	}
	
	func toData() -> Data? {
		do {
			let encoder = JSONEncoder()
			encoder.dateEncodingStrategy = .formatted(Self.dateFormatter)
			if #available(iOS 11.0, *) {
				encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
			} else {
				encoder.outputFormatting = [.prettyPrinted]
			}
			
			let data = try encoder.encode(self)
			return data
		} catch {
			debugPrint("[JSONCodable][toData]error: \(error)")
			return nil
		}
	}
	
	func toJson() -> JSON? {
		guard let data = self.toData() else { return nil }
		
		do {
			let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON
			return json
		} catch {
			debugPrint("[JSONCodable][toJson]error: \(error)")
			return nil
		}
	}
	
}

// MARK: - JSONCodable

typealias JSONCodable = JSONDecodable & JSONEncodable
