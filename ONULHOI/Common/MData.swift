//
//  MData.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 8..
//  Copyright © 2017년 pplus. All rights reserved.
//

import Foundation
import CryptoSwift

// MARK: - Static Values

extension MData {
	
	static let deviceId: String = {
		if let deviceId = UserDefaults.standard.object(forKey: "ApplicationUniqueIdentifier") as? String {
			return deviceId
		}
		
		let deviceId = UUID().uuidString
		UserDefaults.standard.set(deviceId, forKey: "ApplicationUniqueIdentifier")
		UserDefaults.standard.synchronize()
		
		return deviceId
	}()
	static let platform: NEPlatform = .ios
	
	static let appKey = Bundle.main.bundleIdentifier
	static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	static let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    static let appType = "lulla"

}

// MARK: - MData

enum UserType: Int, JSONCodable {
    case leader = 1
    case subLeader
    case teacher
    case subTeacher
    case parents
}

extension MData {
	
	enum Target {
		case user, biz
	}
	
	class var target: Target {
		switch appKey {
		case "com.lullaapp.ios": return .user
		case "com.lullaapp.ios.biz": return .biz
		default: return .user
		}
	}
}

final class MData {
	
	static let shared = MData()
	
    var id: String {
        get {
            return loadForDecrypt(forKey: "id")
        }
        set {
            saveForEncrypt(string: newValue, forKey: "id")
        }
    }

	var loginId: String {
		get {
			return loadForDecrypt(forKey: "loginId")
		}
		set {
			saveForEncrypt(string: newValue, forKey: "loginId")
		}
	}
	
    var password: String {
        get {
            return loadForDecrypt(forKey: "password")
        }
        set {
            saveForEncrypt(string: newValue, forKey: "password")
        }
    }
    
    var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "accessToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "accessToken")
            UserDefaults.standard.synchronize()
        }
    }
	
	private func saveForEncrypt(string: String, forKey key: String) {
		do {
			let enc = try string.encrypt()
			UserDefaults.standard.set(enc, forKey: key)
			UserDefaults.standard.synchronize()
		} catch {
		}
	}
	
	private func loadForDecrypt(forKey key: String) -> String {
		do {
			return try UserDefaults.standard.string(forKey: key)?.decrypt() ?? ""
		} catch {
			return ""
		}
	}
}

// MARK: - Encryption Extension

extension String {
	
	func encrypt() throws -> String? {
		guard let data = self.data(using: .utf8) else { return nil }
		
		let enc = try AES(key: PPCST.AES256.key.bytes, blockMode: CBC(iv: PPCST.AES256.iv.bytes)).encrypt(data.bytes)
		let encData = Data(bytes: enc, count: Int(enc.count))
		
		return encData.base64EncodedString()
	}
	
	func decrypt() throws -> String? {
		guard let data =  Data(base64Encoded: self) else { return nil }
		
		let dec = try AES(key: PPCST.AES256.key.bytes, blockMode: CBC(iv: PPCST.AES256.iv.bytes)).decrypt(data.bytes)
		let decData = Data(bytes: dec, count: Int(dec.count))
		
		return String(data: decData, encoding: .utf8)
	}
	
}
