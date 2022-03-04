//
//  Defines.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 1..
//  Copyright © 2017년 Mac. All rights reserved.
//

import UIKit

struct PPCST {
	
    /// 개발서버 Target
    ///
    /// - dev: 개발 서버
    /// - real: 운영 서버
    enum ServerTarget {
        case dev
        case real
    }
	
    static let serverTarget: ServerTarget = {
//        #if DEBUG
            return .dev
//        #else
//            return .real
//        #endif
    }()
	
    static let AppScheme = "lulla"
	static let appleId = 1539607986
    static let appStoreUrl = "https://itunes.apple.com/app/id1539607986"
    static let mainColor = UIColor.hexColor(0xfd6660)!
    
//    static let naverClientId = "LW3EVDxJsup_kDfs3TZh"
    
	struct AES256 {
		static let key = "(m/indw#are3work~sppl_usp@bi0z-!"
		static let iv = "d#lw^odl&s8ubm!w"
	}
	
	struct Rest {
		static let baseURL: String = {
			switch serverTarget {
			case .dev: return "https://feature2.partner-api.onul-hoi.com"
			case .real: return "https://partner-api.onul-hoi.com"
			}
		}()
		
		static let apiUri = "/partner/api/v1_0/"
	}
	
	struct Bootpay {
		static let applicationID: String = {
			switch serverTarget {
			case .dev: return "5c00fb0fb6d49c08cce3cc2b"
			case .real: return "5bad94dab6d49c5a1b52ee75"
			}
		}()
	}
	
	struct Kakao {
		static let appKey = "5a4021cd4cfcc9f1ebab8dba8772f8a7"
		static let restAPIKey = "821d16d3fca2032e92a117ee4a627b49"
	}

    struct URL {
        static let surveyCreate = "http://lulla-web.s3-website.ap-northeast-2.amazonaws.com/create-survey"
        static let surveyResult = "http://lulla-web.s3-website.ap-northeast-2.amazonaws.com/survey"
        static let surveyAnswer = "http://lulla-web.s3-website.ap-northeast-2.amazonaws.com/submit-answer"
        static let surveyAnswerModify = "http://lulla-web.s3-website.ap-northeast-2.amazonaws.com/update-answer"
        static let surveyModify = "http://lulla-web.s3-website.ap-northeast-2.amazonaws.com/update-survey"
    }
    
	struct Coordinate {
		static let latitude = 37.4876057
		static let longitude = 127.0107591
	}
	
	struct Validate {
		static let postAttachmentMaxCount = 10
	}
	
	static let latestKeywordsCount = 10
    static let hashtagMaxCount = 10
    
    static let bolExchangeMin: Int64 = 10000
	
}

func m_execute(_ delay:Double, closure:@escaping ()->()) {
	DispatchQueue.main.asyncAfter(
		deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure
	)
}

func HSTR(_ key: String) -> String {
	return NSLocalizedString(key, comment: "")
}

func HTempSTR(_ key: String) -> String {
	return NSLocalizedString(key, comment: "")
}

struct HDummy {
    static func value<T>(_ value: T) -> T {
        return value
    }
}

struct HSkip {
    static func value<T>(_ value: T) -> T {
        return value
    }
}

func m_calculateSize(attributedText: NSAttributedString, constrainedToSize: CGSize) -> CGSize {
	//let options: NSStringDrawingOptions = [.UsesLineFragmentOrigin, .UsesFontLeading]
	let options: NSStringDrawingOptions = [.usesLineFragmentOrigin]
	let rect = attributedText.boundingRect(with: constrainedToSize, options: options, context: nil)
	return CGSize(width: ceil(rect.size.width), height: ceil(rect.size.height))
}

func m_calculateSize(text: String, font: UIFont, constrainedToSize: CGSize) -> CGSize {
	let attributes: [NSAttributedString.Key : Any] = [.font: font]
	let attributedText = NSAttributedString(string: text, attributes: attributes)
	return m_calculateSize(attributedText: attributedText, constrainedToSize: constrainedToSize)
}

