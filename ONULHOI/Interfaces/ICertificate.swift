//
//  ICertificate.swift
//  Lulla
//
//  Created by 김영민 on 2021/02/28.
//

import UIKit

enum CertiType: Int, JSONCodable {
    case join
    case email
    case password
}

class Verify: JSONEncodable {
    var phone: String?
    var type: Int?
    var code: String?
}
class Body: JSONEncodable {
    var verify: Verify = Verify()
}

protocol ICertificate {
    typealias Completion = (String?) -> Void
    func reqCerti(type: CertiType, phone: String, completion: Completion?)
    func reqCertiCheck(type: CertiType, phone: String, code: String, completion: Completion?)
}
