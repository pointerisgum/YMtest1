//
//  MDatabase.swift
//  Lulla
//
//  Created by Mac on 2018. 8. 28..
//  Copyright © 2018년 pplus. All rights reserved.
//

import Foundation

//final class RMContact: Object {
//
//	@objc dynamic var mobile: String = "unknown"
//	@objc dynamic var fullName: String?
//	@objc dynamic var updateDate: Date?
//
//	override class func primaryKey() -> String? {
//		return "mobile"
//	}
//
//}

final class MDatabase {
	
//	static let shared = MDatabase()
//
//	lazy var configuration: Realm.Configuration = {
//		var configuration = Realm.Configuration()
//		configuration.schemaVersion = 1
//		configuration.migrationBlock = { migration, oldSchemaVersion in
//		}
//
//		return configuration
//	}()
//
//	lazy var realm: Realm = try! Realm(configuration: configuration)
//	lazy var contacts = realm.objects(RMContact.self)
//
//	func clear() {
//		DispatchQueue.realm.async {
//			autoreleasepool {
//				do {
//					let realm = try Realm()
//
//					realm.beginWrite()
//					realm.delete(realm.objects(RMContact.self))
//					try realm.commitWrite()
//				} catch {
//					print("[MDatabase clear]error: \(error)")
//				}
//			}
//		}
//	}
	
}

//extension DispatchQueue {
//	static let realm = DispatchQueue(label: "com.PPleCompany.PNumber" + UUID().uuidString)
//}
