//
//  NDScan.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/17.
//

import Foundation

final class NDScan: JSONCodable {
    
    var inventoriesQuantity: Int?
    var currentScannedQuantity: Int?
    var outboundId: Int?
    var partnerOutboundAt: String?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        inventoriesQuantity = container.safeDecodeIfPresent(forKey: .inventoriesQuantity)
        currentScannedQuantity = container.safeDecodeIfPresent(forKey: .currentScannedQuantity)
        outboundId = container.safeDecodeIfPresent(forKey: .outboundId)
        partnerOutboundAt = container.safeDecodeIfPresent(forKey: .partnerOutboundAt)
    }
}
