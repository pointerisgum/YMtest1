//
//  NDIssueDetail.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/10.
//

import Foundation

final class NDIssueDetail: JSONCodable {
    
    var receiptDate: String?
    var serialNumber: [String]?
    var skuIssueShortQuantityDelays: [SkuIssueShortQuantityDelays]?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        receiptDate = container.safeDecodeIfPresent(forKey: .receiptDate)
        serialNumber = container.safeDecodeIfPresent(forKey: .serialNumber)
        skuIssueShortQuantityDelays = container.safeDecodeIfPresent(forKey: .skuIssueShortQuantityDelays)
    }
    
    func serialList() -> [String]? {
        var items: [String] = []
        serialNumber?.forEach({
            let stringArray = $0.components(separatedBy: "_")
            if stringArray.count >= 3 {
                items.append((stringArray.first ?? "") + "__" + (stringArray.last ?? ""))
            }
        })
        return items
    }
}

extension NDIssueDetail {
    class SkuIssueShortQuantityDelays: JSONCodable {
        var name: String?
        var reason: String?
        var reasonDetail: String?
        var receiptDate: String?

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            name = container.safeDecodeIfPresent(forKey: .name)
            reason = container.safeDecodeIfPresent(forKey: .reason)
            reasonDetail = container.safeDecodeIfPresent(forKey: .reasonDetail)
            receiptDate = container.safeDecodeIfPresent(forKey: .receiptDate)
        }
    }
}

