//
//  NDOrder.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/13.
//

import Foundation

final class NDOrder: JSONCodable {
    
    var orderType: String?
    var orderStatus: String?
    var inboundAtOperationInventoryQuantityWithSkuMap: OrderDetail?
    var currentTotalScannedInventoryCounts: Int?
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        orderType = container.safeDecodeIfPresent(forKey: .orderType)
        orderStatus = container.safeDecodeIfPresent(forKey: .orderStatus)
        inboundAtOperationInventoryQuantityWithSkuMap = container.safeDecodeIfPresent(forKey: .inboundAtOperationInventoryQuantityWithSkuMap)
        currentTotalScannedInventoryCounts = container.safeDecodeIfPresent(forKey: .currentTotalScannedInventoryCounts)
    }
}

extension NDOrder {
    class OrderDetail: JSONCodable {
        var 광명DC: [InboundAtOperationInventoryQuantityWithSkuMap]?
        var 성수DC: [InboundAtOperationInventoryQuantityWithSkuMap]?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            광명DC = container.safeDecodeIfPresent(forKey: .광명DC)
            성수DC = container.safeDecodeIfPresent(forKey: .성수DC)
        }
    }
    
    class InboundAtOperationInventoryQuantityWithSkuMap: JSONCodable {
        var skuName: String?
        var purchaseQuantity: Int?
        var inboundQuantity: Int?
        var currentScannedQuantity: Int?
        var expectedReceiptDate: String?
        var receiptDate: String?
        var orderStatus: String?
        var inventoryIds: [Int]?
        var changeStatus: ChangeStatus?
        var inboundReceiptDateChangeHistories: [InboundReceiptDateChangeHistories]?
        var operationInventoryChangeHistories: [OperationInventoryChangeHistories]?
        var dcName: String?
        var dcId: Int?
        var inboundTime: String?

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            skuName = container.safeDecodeIfPresent(forKey: .skuName)
            purchaseQuantity = container.safeDecodeIfPresent(forKey: .purchaseQuantity)
            inboundQuantity = container.safeDecodeIfPresent(forKey: .inboundQuantity)
            currentScannedQuantity = container.safeDecodeIfPresent(forKey: .currentScannedQuantity)
            expectedReceiptDate = container.safeDecodeIfPresent(forKey: .expectedReceiptDate)
            receiptDate = container.safeDecodeIfPresent(forKey: .receiptDate)
            orderStatus = container.safeDecodeIfPresent(forKey: .orderStatus)
            inventoryIds = container.safeDecodeIfPresent(forKey: .inventoryIds)
            changeStatus = container.safeDecodeIfPresent(forKey: .changeStatus)
            inboundReceiptDateChangeHistories = container.safeDecodeIfPresent(forKey: .inboundReceiptDateChangeHistories)
            operationInventoryChangeHistories = container.safeDecodeIfPresent(forKey: .operationInventoryChangeHistories)
            dcName = container.safeDecodeIfPresent(forKey: .dcName)
            dcId = container.safeDecodeIfPresent(forKey: .dcId)
            inboundTime = container.safeDecodeIfPresent(forKey: .inboundTime)
        }
    }
    
    class ChangeStatus: JSONCodable {
        var code: CodeType?
        var desc: String?
//        var codeType: CodeType?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            code = container.safeDecodeIfPresent(forKey: .code)
            desc = container.safeDecodeIfPresent(forKey: .desc)
        }
    }
    
    class InboundReceiptDateChangeHistories: JSONCodable {
        var id: Int?
        var status: String?
        var beforeReceiptDate: String?
        var afterReceiptDate: String?
        var companyReason: String?
        var userReason: String?

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = container.safeDecodeIfPresent(forKey: .id)
            status = container.safeDecodeIfPresent(forKey: .status)
            beforeReceiptDate = container.safeDecodeIfPresent(forKey: .beforeReceiptDate)
            afterReceiptDate = container.safeDecodeIfPresent(forKey: .afterReceiptDate)
            companyReason = container.safeDecodeIfPresent(forKey: .companyReason)
            userReason = container.safeDecodeIfPresent(forKey: .userReason)
        }
    }
    
    class OperationInventoryChangeHistories: JSONCodable {
        var id: Int?
        var operationInventoryChangeType: String?
        var beforeQuantity: Int?
        var afterQuantity: Int?

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = container.safeDecodeIfPresent(forKey: .id)
            
            operationInventoryChangeType = container.safeDecodeIfPresent(forKey: .operationInventoryChangeType)
            beforeQuantity = container.safeDecodeIfPresent(forKey: .beforeQuantity)
            afterQuantity = container.safeDecodeIfPresent(forKey: .afterQuantity)
        }
    }

    
}

extension NDOrder.ChangeStatus {
    enum CodeType: String, JSONCodable {
        case CHANGABLE
        case CHANGING
        case REJECT
    }
}
