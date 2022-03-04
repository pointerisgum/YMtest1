//
//  NDHome.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/04.
//

import Foundation

final class NDHome: JSONCodable {
    
    var name: String?
//    var operationInventoryCountResponse = OperationInventoryCountResponse.init()
    var operationInventoryCountResponse: OperationInventoryCountResponse?
    var operationCompanyAlertsResponseList: [Alert]?
    var issueCountsResponse: IssueCountsResponse?
    
    var predictTotalAmount: Int?
    var temporaryPassword: Bool?
    var settlementMonth: String?
    var confirmedAmount: Int?
    
    init() {
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = container.safeDecodeIfPresent(forKey: .name)
        operationCompanyAlertsResponseList = container.safeDecodeIfPresent(forKey: .operationCompanyAlertsResponseList)
        issueCountsResponse = container.safeDecodeIfPresent(forKey: .issueCountsResponse)
        predictTotalAmount = container.safeDecodeIfPresent(forKey: .predictTotalAmount)
        temporaryPassword = container.safeDecodeIfPresent(forKey: .temporaryPassword)
        settlementMonth = container.safeDecodeIfPresent(forKey: .settlementMonth)
        confirmedAmount = container.safeDecodeIfPresent(forKey: .confirmedAmount)
        operationInventoryCountResponse = container.safeDecodeIfPresent(forKey: .operationInventoryCountResponse)
        
        
    }
    
}

extension NDHome {
    class OperationInventoryCountResponse: JSONCodable {
        var totalCountForMain:TotalCountForMain?
        var dailyCountMap: String?
        var storeCountMap: String?
        var unDailyCountMap: String?
        var dailyOrderStatus: String?
        var dailyOrderType: String?
        var dailyInventoryIds: [String]?
        var unDailyInventoryIds: [String]?
        var unDailyOrderStatus: String?
        
        init() {
            
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            dailyCountMap = container.safeDecodeIfPresent(forKey: .dailyCountMap)
            storeCountMap = container.safeDecodeIfPresent(forKey: .storeCountMap)
            unDailyCountMap = container.safeDecodeIfPresent(forKey: .unDailyCountMap)
            dailyOrderStatus = container.safeDecodeIfPresent(forKey: .dailyOrderStatus)
            dailyOrderType = container.safeDecodeIfPresent(forKey: .dailyOrderType)
            dailyInventoryIds = container.safeDecodeIfPresent(forKey: .dailyInventoryIds)
            unDailyInventoryIds = container.safeDecodeIfPresent(forKey: .unDailyInventoryIds)
            totalCountForMain = container.safeDecodeIfPresent(forKey: .totalCountForMain)
            unDailyOrderStatus = container.safeDecodeIfPresent(forKey: .unDailyOrderStatus)
        }
    }

    class TotalCountForMain: JSONCodable {
//        var name: String?
//        var count: Int?
        var 광명DC: Int?
        var 성수DC: Int?

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            광명DC = container.safeDecodeIfPresent(forKey: .광명DC)
            성수DC = container.safeDecodeIfPresent(forKey: .성수DC)
        }
        
//        init(name: String?, count: Int?) {
//            self.name = name
//            self.count = count
//        }
    }
    
    class Alert: JSONCodable {
        var id: Int?
        var alertType: String?
        var message: String?

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = container.safeDecodeIfPresent(forKey: .id)
            alertType = container.safeDecodeIfPresent(forKey: .alertType)
            message = container.safeDecodeIfPresent(forKey: .message)
            
        }
    }
}

extension NDHome {
    class IssueCountsResponse: JSONCodable {
        var totalExpectedReceiptCounts: Int?
        var totalIssueCounts: Int?
        var reasonCounts: [ReasonCounts]?

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            totalExpectedReceiptCounts = container.safeDecodeIfPresent(forKey: .totalExpectedReceiptCounts)
            totalIssueCounts = container.safeDecodeIfPresent(forKey: .totalIssueCounts)
            reasonCounts = container.safeDecodeIfPresent(forKey: .reasonCounts)
            
        }
    }
    
    class ReasonCounts: JSONCodable {
        var reason: Reason?
        var counts: Int?

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            reason = container.safeDecodeIfPresent(forKey: .reason)
            counts = container.safeDecodeIfPresent(forKey: .counts)
            
        }
    }
    
    class Reason: JSONCodable {
        var code: String?
        var desc: String?

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            code = container.safeDecodeIfPresent(forKey: .code)
            desc = container.safeDecodeIfPresent(forKey: .desc)
        }
    }
}
