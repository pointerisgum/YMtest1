//
//  Dictionary+M.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 8..
//  Copyright © 2017년 pplus. All rights reserved.
//

import Foundation

extension Dictionary {
	
	var prettyDescription: String {
		do {
			let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
			let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
			
			return (string as String?) ?? ""
		} catch {
			print("error: \(error)")
		}
		
		return ""
		//return (self as AnyObject)
	}
	
}

extension Dictionary {
	
	/// Dictionary `+` operator for combine two dictionary into one.
	/// - Note: There is `no` handling for `duplicate`, duplicate on the right side would replaceing values on the left side, should use with caution.
	/// In case duplicate handing is require, don't use this methode.
	/// - Parameters:
	///   - lhs: dictionary on the left side of the operator.
	///   - rhs: dictionary on the right side of the operator.
	/// - Returns: New dictionary with combining values of two dictionary.
	static public func + (lhs: [Key: Value], rhs: [Key: Value]?) -> [Key: Value] {
		guard let rhs = rhs else { return lhs }
		
		var result = lhs
		for (key, value) in rhs {
			result[key] = value
		}
		return result
	}
	
	/// Dictionary `+=` operator for combine two dictionary into one.
	/// - Note: There is `no` handling for `duplicate`, duplicate on the right side would replaceing values on the left side, should use with caution.
	/// In case duplicate handing is require, don't use this methode.
	/// - Parameters:
	///   - left: dictionary on the left side of the operator that including values of dictionary from right side.
	///   - right: dictionary on the right side of the operator.
	static public func += (left: inout [Key: Value], right: [Key: Value]) {
		right.forEach {left[$0.key] = $0.value}
	}
	
}
