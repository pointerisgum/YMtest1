//
//  NDCommListItem.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/04.
//

import Foundation

final class NDCommListItem {
    
    enum ListType {
        case header
        case contents
        case timeHeader
        case timeSubHeader
        case timeContents
        case button(title: String)
        case alarmContents
        case space(height: CGFloat)
        case keepContents
        case releaseContents
    }
    
    var listType: ListType!
    var title: String?
    var count: Int = 0
//    var delivery: String?
//    var descrip: String?
    var iconName: String?
    var color: UIColor?
    var contents: String?
    var status: NDOrder.ChangeStatus.CodeType?
    var data: NDOrder.InboundAtOperationInventoryQuantityWithSkuMap?
    var scanCount: Int?
    var datas: [NDOrder.InboundAtOperationInventoryQuantityWithSkuMap]?
    var dcId: Int?
    var isFinish: Bool
    
    //status = 도착일 변경 (버튼)
    //contents 대만 라즈베리 샌드위치
    init(listType: ListType, title: String? = "", count: Int? = 0, iconName: String? = nil, color: UIColor? = nil, contents: String? = nil, status: NDOrder.ChangeStatus.CodeType? = nil, data: NDOrder.InboundAtOperationInventoryQuantityWithSkuMap? = nil, scanCount: Int? = nil, datas: [NDOrder.InboundAtOperationInventoryQuantityWithSkuMap]? = nil, dcId: Int? = nil, isFinish: Bool = false) {
        self.listType = listType
        self.title = title
        self.count = count ?? 0
//        self.delivery = delivery
//        self.descrip = descrip
        self.iconName = iconName
        self.color = color
        self.contents = contents
        self.status = status
        self.data = data
        self.scanCount = scanCount
        self.datas = datas
        self.dcId = dcId
        self.isFinish = isFinish
    }

}
