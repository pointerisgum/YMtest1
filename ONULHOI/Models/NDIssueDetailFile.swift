//
//  NDIssueDetailFile.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/10.
//

import Foundation

final class NDIssueDetailFile: JSONCodable {
    
    var productName: String?
    var createdAt: String?
    var reasonDetail: String?
    var inboundInfoImagesList: [String]?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        productName = container.safeDecodeIfPresent(forKey: .productName)
        createdAt = container.safeDecodeIfPresent(forKey: .createdAt)
        reasonDetail = container.safeDecodeIfPresent(forKey: .reasonDetail)
        inboundInfoImagesList = container.safeDecodeIfPresent(forKey: .inboundInfoImagesList)
    }
}
