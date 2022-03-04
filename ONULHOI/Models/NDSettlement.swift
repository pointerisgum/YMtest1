//
//  NDSettlement.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/06.
//

import Foundation

final class NDSettlement: JSONCodable {
    
    var bankInfo: String?
    var expectedSettlementAmount: Int64?
    var settlementMethod: Int?
    var dailySettlementResponseList: [DailySettlementResponse]?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        bankInfo = container.safeDecodeIfPresent(forKey: .bankInfo)
        expectedSettlementAmount = container.safeDecodeIfPresent(forKey: .expectedSettlementAmount)
        settlementMethod = container.safeDecodeIfPresent(forKey: .settlementMethod)
        dailySettlementResponseList = container.safeDecodeIfPresent(forKey: .dailySettlementResponseList)
    }
}

extension NDSettlement {
    class DailySettlementResponse: JSONCodable {
        var receiptDate: String?
        var dailySettlementSum: Int64?
        var calculatedPrices: [CalculatedPrice]?

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            receiptDate = container.safeDecodeIfPresent(forKey: .receiptDate)
            dailySettlementSum = container.safeDecodeIfPresent(forKey: .dailySettlementSum)
            calculatedPrices = container.safeDecodeIfPresent(forKey: .calculatedPrices)
        }
    }
    
    class CalculatedPrice: JSONCodable {
        var operationProductUnitId: Int?
        var name: String?
        var totalPurchasingPrice: Int64?
        var purchasingPrice: Int64?
        var receiptCount: Int?
        var productStatus: String?
        var receiptDate: String?

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            operationProductUnitId = container.safeDecodeIfPresent(forKey: .operationProductUnitId)
            name = container.safeDecodeIfPresent(forKey: .name)
            totalPurchasingPrice = container.safeDecodeIfPresent(forKey: .totalPurchasingPrice)
            purchasingPrice = container.safeDecodeIfPresent(forKey: .purchasingPrice)
            receiptCount = container.safeDecodeIfPresent(forKey: .receiptCount)
            productStatus = container.safeDecodeIfPresent(forKey: .productStatus)
            receiptDate = container.safeDecodeIfPresent(forKey: .receiptDate)
        }
    }
}
