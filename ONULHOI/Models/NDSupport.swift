//
//  NDSupport.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/05.
//

import Foundation

final class NDSupport: JSONCodable {
    
    var managerName: String?
    var managerPhoneNumber: String?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        managerName = container.safeDecodeIfPresent(forKey: .managerName)
        managerPhoneNumber = container.safeDecodeIfPresent(forKey: .managerPhoneNumber)
    }

}
