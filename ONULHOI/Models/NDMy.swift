//
//  NDMy.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/05.
//

import Foundation

final class NDMy: JSONCodable {
    
    var businessRegistrationNumber: String?
    var businessName: String?
    var representName: String?
    var representEmail: String?
    var representPhoneNumber: String?
    var generalPhoneNumber: String?
    var bankInfo: String?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        businessRegistrationNumber = container.safeDecodeIfPresent(forKey: .businessRegistrationNumber)
        businessName = container.safeDecodeIfPresent(forKey: .businessName)
        representName = container.safeDecodeIfPresent(forKey: .representName)
        representEmail = container.safeDecodeIfPresent(forKey: .representEmail)
        representPhoneNumber = container.safeDecodeIfPresent(forKey: .representPhoneNumber)
        generalPhoneNumber = container.safeDecodeIfPresent(forKey: .generalPhoneNumber)
        bankInfo = container.safeDecodeIfPresent(forKey: .bankInfo)
    }

}
