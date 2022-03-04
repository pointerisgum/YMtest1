//
//  NDWeekOrder.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/13.
//

import Foundation

final class NDWeekOrder: JSONCodable {
    
    var expectedReceiptDate: String?
    var predictNextWeekList: [PredictNextWeekList]?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        expectedReceiptDate = container.safeDecodeIfPresent(forKey: .expectedReceiptDate)
        predictNextWeekList = container.safeDecodeIfPresent(forKey: .predictNextWeekList)
    }
}

extension NDWeekOrder {
    class PredictNextWeekList: JSONCodable {
        var id: Int?
        var expectedReceiptDate: String?
        var productName: String?
        var counts: Int?

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = container.safeDecodeIfPresent(forKey: .id)
            expectedReceiptDate = container.safeDecodeIfPresent(forKey: .expectedReceiptDate)
            productName = container.safeDecodeIfPresent(forKey: .productName)
            counts = container.safeDecodeIfPresent(forKey: .counts)
        }
    }
}
