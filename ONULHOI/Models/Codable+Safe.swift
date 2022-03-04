//
//  Codable+Safe.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 5..
//  Copyright © 2017년 Mac. All rights reserved.
//

import Foundation

// MARK: - KeyedDecodingContainer Extension

protocol KeyedDecodingContainerDefaultValue {
	static var defaultValue: Self { get }
}

extension Int: KeyedDecodingContainerDefaultValue {
	static var defaultValue: Int { return 0 }
}

extension Int64: KeyedDecodingContainerDefaultValue {
	static var defaultValue: Int64 { return 0 }
}

extension String: KeyedDecodingContainerDefaultValue {
	static var defaultValue: String { return "" }
}

extension Double: KeyedDecodingContainerDefaultValue {
	static var defaultValue: Double { return 0 }
}

extension Date: KeyedDecodingContainerDefaultValue {
	static var defaultValue: Date { return Date() }
}

extension Bool: KeyedDecodingContainerDefaultValue {
	static var defaultValue: Bool { return false }
}

protocol KeyedDecodingContainerDefaultValue_ {
	static func defaultValue() -> Self
}

extension KeyedDecodingContainer {
	
	private func decodedValue<T>(type: T.Type, forKey key: K) -> Any? where T: Decodable {
		switch type {
		case is Int.Type:
			if let value = try? decode(Int.self, forKey: key) {
				return value
			} else if let value = try? decode(String.self, forKey: key) {
				return value.toInt()
			} else if let value = try? decode(Bool.self, forKey: key) {
				return (value ? 1 : 0)
			}
		case is Int64.Type:
			if let value = try? decode(Int64.self, forKey: key) {
				return value
			} else if let value = try? decode(String.self, forKey: key) {
				return value.toInt64()
			} else if let value = try? decode(Bool.self, forKey: key) {
				return (value ? 1 : 0)
			}
		case is String.Type:
			if let value = try? decode(String.self, forKey: key) {
				return value
			} else if let value = try? decode(Int.self, forKey: key) {
				return String(value)
			} else if let value = try? decode(Double.self, forKey: key) {
				return String(value)
			} else if let value = try? decode(Bool.self, forKey: key) {
				return String(value)
			}
		case is Bool.Type:
			if let value = try? decode(Bool.self, forKey: key) {
				return value
			} else if let value = try? decode(String.self, forKey: key) {
				return value.toBool()
			} else if let value = try? decode(Int.self, forKey: key) {
				return (value > 0)
			}
		case is Double.Type:
			if let value = try? decode(Double.self, forKey: key) {
				return value
			} else if let value = try? decode(String.self, forKey: key) {
				return value.toDouble()
			}
		default:()
		}
		
		return try? decode(type, forKey: key)
	}
	
	func safeDecodeIfPresent<T>(forKey key: K) -> T? where T: Decodable {
		return decodedValue(type: T.self, forKey: key) as? T
	}
	
	func safeDecode<T>(forKey key: K, defaultValue: T = T.defaultValue ) -> T where T: Decodable & KeyedDecodingContainerDefaultValue {
		return safeDecodeIfPresent(forKey: key) ?? defaultValue
	}
	
	func safeDecode<T>(forKey key: K, defaultValue: T = T.defaultValue ) -> T where T: Decodable & EnumDefaultValue {
		return safeDecodeIfPresent(forKey: key) ?? defaultValue
	}
	
//	func safeDecode<T>(forKey key: K) -> T where T: JSONCodable {
//		return safeDecodeIfPresent(forKey: key) ?? T(data: <#T##Data?#>)
//	}
	
	func safeDecode<T>(forKey key: K) -> [T] where T: JSONCodable {
		return safeDecodeIfPresent(forKey: key) ?? []
	}
	
}

//extension KeyedDecodingContainer {
//	
//	func decodeIfPresent<T>(_ key: KeyedDecodingContainer.Key) throws -> T? where T: Decodable {
//		return try decodeIfPresent(T.self, forKey: key)
//	}
//	
//	func decode<T>(_ key: KeyedDecodingContainer.Key) throws -> T where T: Decodable {
//		return try decode(T.self, forKey: key)
//	}
//	
//	func decode<T>(_ key: KeyedDecodingContainer.Key) throws -> [T] where T: Decodable {
//		return try decode([T].self, forKey: key)
//	}
//	
//	subscript<T>(key: Key) -> T? where T: Decodable {
//		return try? decode(T.self, forKey: key)
//	}
//	
//	subscript<T>(key: Key) -> T where T: Decodable & KeyedDecodingContainerDefaultValue {
//		return (try? decode(T.self, forKey: key)).unwrapped(or: T.defaultValue)
//	}
//	
//}

