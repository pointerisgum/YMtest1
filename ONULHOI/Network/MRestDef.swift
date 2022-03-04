//
//  MRestDef.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 1..
//  Copyright © 2017년 Mac. All rights reserved.
//

import Foundation

extension MRest {
	
	enum Code {
		case none
		case success
		case errNetwork
		case errServer
		case errInvalidData
	}
	
}

extension MRest {
	
	enum PageVersion {
		case v1, v2
	}
	
	static let defaultSz = 30
	
	@discardableResult class func configurePage(version: PageVersion = .v1, parameters: inout JSON, count: Int) -> Int {
        let page = (count + defaultSz - 1)/defaultSz + 1
        parameters[Keys.page] = page
        return page
	}
}

extension MRest {
	
	enum Path: String {
        case file = "file"
        case login = "login"
        case logout = "logout/success"
        case changePassword = "operation-companies/password"
        case findPassword = "operation-companies/find-password"
        case home = "operation-companies/home"
        case myPage = "operation-companies"
        case support = "operation-companies/support"
        case alerts = "alerts"

        //발주
        case operationInventoriesOrderCount = "operation-inventories/order/count"
        case freshOrderDetail = "operation-inventories/daily/order"
        case keepOrderDetail = "operation-inventories/store/order"
        case weekOrder = "operation-inventories/predict-next-week-counts"
        case changeDate = "operation-inventories/change-receipt-date"
//        case updateOrder = "operation-inventories/order-status"


        //출고
        case release = "operation-inventories/outbound/count"
        case freshReleaseDetail = "operation-inventories/daily/outbound"
        case keepReleaseDetail = "operation-inventories/store/outbound"
        case scanning = "operation-companies/partner-outbound-scanning"
        case scanList = "operation-companies/scanned"
        case orderStatus = "operation-inventories/order-status"

        
        //정산
        case settlement = "operation-companies/partner-settlement"
        
        //이슈
        case issuesSummary = "issues/summary"
        case issuesInboundInfosDetail = "issues/inbound-infos/detail"
        case issuesInboundInfosSerialNumber = "issues/inbound-infos/serial-number"
	}
}

struct Keys {
	
    static let id = "businessRegistrationNumber"
    static let password = "password"
    
    static let currentPlainPassword = "currentPlainPassword"
    static let plainPassword = "plainPassword"
    static let page = "page"

	struct Date {
		static let fromDate = "fromDate"
		static let toDate = "toDate"
	}

    static let reason = "reason"
    static let serialNumber = "serialNumber"
    static let receiptDate = "receiptDate"
    static let dcId = "dcId"
    static let skuCode = "skuCode"
    static let operationInventoryIdList = "operationInventoryIdList"
    static let requestDate = "requestDate"
    static let inventoryIds = "inventoryIds"
    static let inventoryOrderStatus = "inventoryOrderStatus"
    static let expectedReceiptDate = "expectedReceiptDate"
    static let operationCompanyAlertId = "operationCompanyAlertId"
}

