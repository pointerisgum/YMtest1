//
//  Array+M.swift
//  Lulla
//
//  Created by iMac 5K on 2017. 12. 13..
//  Copyright © 2017년 pplus. All rights reserved.
//

import Foundation

extension Array {
	
	//	func groupByKey<K: Hashable>(keyForValue: (_ element: Element) throws -> K) rethrows -> [K: [Element]] {
	//		var group = [K: [Element]]()
	//		for value in self {
	//			let key = try keyForValue(value)
	//			group[key] = (group[key] ?? []) + [value]
	//		}
	//		return group
	//	}
	
	func groupByKey<K: Hashable>(keyForValue: (_ element: Element) throws -> K?) rethrows -> [K: [Element]] {
		var group = [K: [Element]]()
		for value in self {
			if let key = try keyForValue(value) {
				group[key] = (group[key] ?? []) + [value]
			}
		}
		return group
	}
	
}

extension Array {
	
	func randomItem() -> Element {
		let index = Int(arc4random_uniform(UInt32(count)))
		return self[index]
	}
	
	mutating func safeAppend(_ newElement: Element?) {
		if let newElement = newElement {
			append(newElement)
		}
	}
    
    mutating func safe_append<S>(contentsOf newElements: S?) where Element == S.Element, S : Sequence {
        if let newElements = newElements {
            append(contentsOf: newElements)
        }
    }
    
    mutating func safeInsert(_ newElement: Element?, at index: Index) {
        if let newElement = newElement, index <= count {
            insert(newElement, at: index)
        }
    }
	
	subscript (safe index: Int?) -> Element? {
		guard let index = index else { return nil }
		
		return indices ~= index ? self[index] : nil
	}
	
	mutating func shuffle() {
		guard count > 1 else { return }
		for index in startIndex..<endIndex - 1 {
			let randomIndex = Int(arc4random_uniform(UInt32(endIndex - index))) + index
			if index != randomIndex { swapAt(index, randomIndex) }
		}
	}
	
	func shuffled() -> [Element] {
		var array = self
		array.shuffle()
		return array
	}
	
}

extension Array where Element: Equatable {
	
	mutating func remove(_ element: Element) {
        if let index = firstIndex(of: element) {
			remove(at: index)
		}
	}
	
	func m_index(of element: Element?) -> Int? {
		if let element = element {
            return firstIndex(of: element)
		}
		return nil
	}
	
	func duplicatesRemoved() -> [Element] {
		// Thanks to https://github.com/sairamkotha for improving the property
		return reduce(into: [Element]()) {
			if !$0.contains($1) {
				$0.append($1)
			}
		}
	}
	
	func isSubArray(of otherArray: [Element]) -> Bool {
		for element in self {
			if otherArray.contains(element) == false {
				return false
			}
		}
		
		return true
	}
	
    func find(value searchValue: String, in array: [String]) -> Int? {
        for (index, value) in array.enumerated() {
            if value == searchValue {
                return index
            }
        }
        return nil
    }
}

