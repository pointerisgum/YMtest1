//
//  OrderDetailViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/12.
//

import UIKit
import NVActivityIndicatorView

extension OrderDetailViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Order", bundle: nil)
}

enum SortType: String {
    case all = "전체보기"
    case SS = "성수DC"
    case GM = "광명DC"
}

extension OrderDetailViewController {
    enum VewType {
        case fresh  //신선상품
        case keep   //보관상품
    }
    
    enum Mode {
        case order      //발주
        case release    //출고
        case scan       //스캔목록
    }
}

class OrderDetailViewController: UMViewController {

    @IBOutlet weak var lb_Title: UILabel! {
        didSet {
            switch mode {
            case .order:
                switch viewType {
                case .fresh:
                    lb_Title.text = "신선상품 발주 내역"
                case .keep:
                    lb_Title.text = "보관상품 발주 내역"
                }
            case .release:
                switch viewType {
                case .fresh:
                    lb_Title.text = "신선상품 출고"
                case .keep:
                    lb_Title.text = "보관상품 출고"
                }
            case .scan:
                lb_Title.text = "스캔목록"
            }
        }
    }
    @IBOutlet weak var lb_Date: UILabel! {
        didSet {
            lb_Date.text = selectDate
        }
    }
    @IBOutlet weak var lb_SortType: UILabel!
    @IBOutlet weak var tbv_SS: UITableView! //성수
    @IBOutlet weak var tbv_GM: UITableView! //광명
    @IBOutlet weak var lc_SSHeight: NSLayoutConstraint!
    @IBOutlet weak var lc_GMHeight: NSLayoutConstraint!
    @IBOutlet weak var v_TotalCount: UIView! {
        didSet {
            if mode == .scan {
                v_TotalCount.isHidden = true
            }
//            switch viewType {
//            case .fresh:
//                v_TotalCount.isHidden = false
//            case .keep:
//                v_TotalCount.isHidden = false
//            }
        }
    }
    @IBOutlet weak var stv_Data: UIStackView! {
        didSet {
            stv_Data.isHidden = true
        }
    }
    @IBOutlet weak var lb_Empty: UILabel! {
        didSet {
            lb_Empty.isHidden = true
        }
    }
    @IBOutlet weak var v_SSBg: UIView!
    @IBOutlet weak var v_GMBg: UIView!
    @IBOutlet weak var btn_Confirm: UIBButton! {
        didSet {
            btn_Confirm.isHidden = true
        }
    }
    @IBOutlet weak var v_DateBg: UIView! {
        didSet {
            if mode == .scan {
                v_DateBg.isHidden = true
            }
        }
    }
    @IBOutlet weak var lb_TotalCount: UILabel!
    @IBOutlet weak var lb_TotalCountTitle: UILabel!
    @IBOutlet weak var btn_Back: UIButton! {
        didSet {
            if isModal == true {
                btn_Back.isHidden = true
            }
        }
    }
    @IBOutlet weak var btn_Close: UIButton! {
        didSet {
            if isModal == true {
                btn_Close.isHidden = false
            }
        }
    }
    
    var mode: Mode = .order
    var viewType: VewType = .fresh
    var sortType: SortType = .all {
        didSet {
            switch sortType {
            case .all:
                lb_SortType.text = SortType.all.rawValue
                v_SSBg.isHidden = false
                v_GMBg.isHidden = false
                if mode == .order {
                    if ssIds.count > 0 && gmIds.count > 0 {
                        btn_Confirm.isHidden = false
                    } else {
                        btn_Confirm.isHidden = true
                    }
                }
            case .SS:
                lb_SortType.text = SortType.SS.rawValue
                v_SSBg.isHidden = false
                v_GMBg.isHidden = true
                if mode == .order {
                    if ssIds.count > 0 {
                        btn_Confirm.isHidden = false
                    } else {
                        btn_Confirm.isHidden = true
                    }
                }
            case .GM:
                lb_SortType.text = SortType.GM.rawValue
                v_SSBg.isHidden = true
                v_GMBg.isHidden = false
                if mode == .order {
                    if gmIds.count > 0 {
                        btn_Confirm.isHidden = false
                    } else {
                        btn_Confirm.isHidden = true
                    }
                }
            }
        }
    }
    var orgDate: Date!
    var selectDate: String!
    var SSItems: [NDCommListItem] = []
    var GMItems: [NDCommListItem] = []
//    var ids: [Int] = []
    var ssIds: [Int] = []
    var gmIds: [Int] = []
    var dcId: Int?
    var isModal: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbv_SS.register(type: ListTimeHeaderCell.self)
        tbv_SS.register(type: ListTimeSubHeaderCell.self)
        tbv_SS.register(type: ListTimeContentsCell.self)
        tbv_SS.register(type: ListTimeHeaderCell.self)
        tbv_SS.register(type: ListKeepContentsCell.self)
        tbv_SS.register(type: ListReleaseCell.self)
        tbv_SS.register(type: ListButtonCell.self)
        tbv_SS.register(type: SpaceCell.self)

        tbv_GM.register(type: ListTimeHeaderCell.self)
        tbv_GM.register(type: ListTimeSubHeaderCell.self)
        tbv_GM.register(type: ListTimeContentsCell.self)
        tbv_GM.register(type: ListTimeHeaderCell.self)
        tbv_GM.register(type: ListKeepContentsCell.self)
        tbv_GM.register(type: ListReleaseCell.self)
        tbv_GM.register(type: ListButtonCell.self)
        tbv_GM.register(type: SpaceCell.self)

//        self.SSItems.append(NDCommListItem.init(listType: .space(height: 18)))
//
//        self.SSItems.append(NDCommListItem.init(listType: .timeHeader, title: HSTR("성수 DC"), count: 33))
//        self.SSItems.append(NDCommListItem.init(listType: .space(height: 12)))
//
//        self.SSItems.append(NDCommListItem.init(listType: .timeSubHeader, title: "09시", count: 12, iconName: "icMorningS", color: UIColor(hex: 0xffa500)))
//        self.SSItems.append(NDCommListItem.init(listType: .space(height: 12)))
//        self.SSItems.append(NDCommListItem.init(listType: .timeContents, title: "상품명이 길경우 상품명이 길경우 줄바꿈 처리함상품명이 길경우 상품명이 길경우 줄바꿈 처리함", count: 3))
//        self.SSItems.append(NDCommListItem.init(listType: .timeContents, title: "상품명 02", count: 21))
//        self.SSItems.append(NDCommListItem.init(listType: .timeContents, title: "상품명 03", count: 4))
//        self.SSItems.append(NDCommListItem.init(listType: .space(height: 6)))
//
//        self.SSItems.append(NDCommListItem.init(listType: .timeSubHeader, title: "13시", count: 12, iconName: "icEveningS", color: UIColor(hex: 0xf86b3f)))
//        self.SSItems.append(NDCommListItem.init(listType: .space(height: 12)))
//        self.SSItems.append(NDCommListItem.init(listType: .timeContents, title: "상품명 01", count: 3))
//        self.SSItems.append(NDCommListItem.init(listType: .timeContents, title: "상품명 02", count: 21))
//        self.SSItems.append(NDCommListItem.init(listType: .timeContents, title: "상품명 03", count: 4))
//        self.SSItems.append(NDCommListItem.init(listType: .space(height: 6)))
//
//        self.SSItems.append(NDCommListItem.init(listType: .timeSubHeader, title: "17시", count: 12, iconName: "icNightS", color: UIColor(hex: 0x7741bc)))
//        self.SSItems.append(NDCommListItem.init(listType: .space(height: 12)))
//        self.SSItems.append(NDCommListItem.init(listType: .timeContents, title: "상품명 01", count: 3))
//        self.SSItems.append(NDCommListItem.init(listType: .timeContents, title: "상품명 02", count: 21))
//        self.SSItems.append(NDCommListItem.init(listType: .timeContents, title: "상품명 03", count: 4))
//
//        self.SSItems.append(NDCommListItem.init(listType: .space(height: 8)))
//
//        self.tbv_SS.reloadData()
//
//
//
//
//        self.GMItems.append(NDCommListItem.init(listType: .space(height: 18)))
//
//        self.GMItems.append(NDCommListItem.init(listType: .timeHeader, title: HSTR("광명 DC"), count: 40))
//        self.GMItems.append(NDCommListItem.init(listType: .space(height: 12)))
//
//        self.GMItems.append(NDCommListItem.init(listType: .keepContents, title: "2021.12.1(수) 도착", count: 4, iconName: "btnOrderDate01", contents: "대만 라즈베리 샌드위치"))
//        self.GMItems.append(NDCommListItem.init(listType: .space(height: 8)))
//        self.GMItems.append(NDCommListItem.init(listType: .keepContents, title: "2021.12.1(수) 도착", count: 50, iconName: "btnOrderDate02", contents: "대만 라즈베리 샌드위치대만 라즈베리 샌드위치대만 라즈베리 샌드위치대만 라즈베리 샌드위치"))
//        self.GMItems.append(NDCommListItem.init(listType: .space(height: 8)))
//        self.GMItems.append(NDCommListItem.init(listType: .keepContents, title: "2021.12.1(수) 도착", count: 4, iconName: "btnOrderDate03", contents: "대만 라즈베리 샌드위치"))
//        self.GMItems.append(NDCommListItem.init(listType: .space(height: 8)))
//
//        self.tbv_GM.reloadData()
//        self.view.setNeedsLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        lc_SSHeight.constant = tbv_SS.contentSize.height
        lc_GMHeight.constant = tbv_GM.contentSize.height
    }
    
    func reload() {
        //성수: 1
        //광명: 2
        var sender: MRest.Sender!
        
        switch self.mode {
        case .order:
            sender = MRest.Sender(path: (viewType == .fresh ? .freshOrderDetail : .keepOrderDetail), method: .get)
            sender.customUrl = PPCST.Rest.baseURL + PPCST.Rest.apiUri + (viewType == .fresh ? MRest.Path.freshOrderDetail.rawValue : MRest.Path.keepOrderDetail.rawValue) +
            "?\(Keys.receiptDate)=\(orgDate.string(fmt: "yyyy-MM-dd"))"
        case .release:
            sender = MRest.Sender(path: (viewType == .fresh ? .freshReleaseDetail : .keepReleaseDetail), method: .get)
            sender.customUrl = PPCST.Rest.baseURL + PPCST.Rest.apiUri + (viewType == .fresh ? MRest.Path.freshReleaseDetail.rawValue : MRest.Path.keepReleaseDetail.rawValue) +
            "?\(Keys.receiptDate)=\(orgDate.string(fmt: "yyyy-MM-dd"))"
        case .scan:
            sender = MRest.Sender(path: .scanList, method: .get)
            sender.customUrl = PPCST.Rest.baseURL + PPCST.Rest.apiUri + MRest.Path.scanList.rawValue +
            "?\(Keys.expectedReceiptDate)=\(orgDate.string(fmt: "yyyy-MM-dd"))" +
            "&dcId=\(dcId!)"
        }
        
        MRest.shared.request(sender) { (resp: MRest.Resp<NARow<NDOrder>>) in
            guard resp.code == .success else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    PPAlert.present(inVC: self, title: resp.message)
                }
                return
            }

            guard let item = resp.object.row else { return }

            if self.mode == .scan {
                self.SSItems.removeAll()

                if resp.array?.count ?? 0 > 0 {

                    let data = resp.array?.first
                    let title = data?["dcName"] as? String
                    let totalCount = data?["totalInventoryCounts"] as? Int
                    let totalScanCnt = data?["currentTotalScannedInventoryCounts"] as? Int
                    self.SSItems.append(NDCommListItem.init(listType: .space(height: 18)))
                    self.SSItems.append(NDCommListItem.init(listType: .timeHeader, title: title, count: totalCount ?? 0, scanCount: totalScanCnt))
                    self.SSItems.append(NDCommListItem.init(listType: .space(height: 12)))
                    
                    let inventoryList: Dictionary? = data?["inventoryList"] as? Dictionary<String, Array<Any>>
                    let morning = inventoryList?["09시"] as? Array<[String:Any]>
                    if morning?.count ?? 0 > 0 {
                        var items: [NDCommListItem] = []
                        var subTotalCnt = 0
                        morning?.forEach({
                            let title = $0["productName"] as? String ?? ""
                            let cnt = $0["quantity"] as? Int
                            let scannedCounts = $0["scannedCounts"] as? Int
                            items.append((NDCommListItem.init(listType: .releaseContents, title:title, count: cnt, contents: title, scanCount: scannedCounts)))
                            subTotalCnt += cnt ?? 0
                        })
                        self.SSItems.append(NDCommListItem.init(listType: .timeSubHeader, title: "09시", count: subTotalCnt, iconName: "icMorningS", color: UIColor(hex: 0xffa500)))
                        self.SSItems.append(NDCommListItem.init(listType: .space(height: 12)))
                        self.SSItems.append(contentsOf: items)
                        self.SSItems.append(NDCommListItem.init(listType: .space(height: 6)))
                    }
                    let afternoon = inventoryList?["13시"] as? Array<[String:Any]>
                    if afternoon?.count ?? 0 > 0 {
                        var items: [NDCommListItem] = []
                        var subTotalCnt = 0
                        afternoon?.forEach({
                            let title = $0["productName"] as? String ?? ""
                            let cnt = $0["quantity"] as? Int
                            let scannedCounts = $0["scannedCounts"] as? Int
                            items.append((NDCommListItem.init(listType: .releaseContents, title:title, count: cnt, contents: title, scanCount: scannedCounts)))
                            subTotalCnt += cnt ?? 0
                        })
                        self.SSItems.append(NDCommListItem.init(listType: .timeSubHeader, title: "13시", count: subTotalCnt, iconName: "icEveningS", color: UIColor(hex: 0xf86b3f)))
                        self.SSItems.append(NDCommListItem.init(listType: .space(height: 12)))
                        self.SSItems.append(contentsOf: items)
                        self.SSItems.append(NDCommListItem.init(listType: .space(height: 6)))
                    }
                    let evening = inventoryList?["15시"] as? Array<[String:Any]>
                    if evening?.count ?? 0 > 0 {
                        var items: [NDCommListItem] = []
                        var subTotalCnt = 0
                        evening?.forEach({
                            let title = $0["productName"] as? String ?? ""
                            let cnt = $0["quantity"] as? Int
                            let scannedCounts = $0["scannedCounts"] as? Int
                            items.append((NDCommListItem.init(listType: .releaseContents, title:title, count: cnt, contents: title, scanCount: scannedCounts)))
                            subTotalCnt += cnt ?? 0
                        })
                        self.SSItems.append(NDCommListItem.init(listType: .timeSubHeader, title: "15시", count: subTotalCnt, iconName: "icNightS", color: UIColor(hex: 0x7741bc)))
                        self.SSItems.append(NDCommListItem.init(listType: .space(height: 12)))
                        self.SSItems.append(contentsOf: items)
                        self.SSItems.append(NDCommListItem.init(listType: .space(height: 6)))
                    }
                }
                
                if self.SSItems.count <= 0 {
                    self.lb_Empty.text = "스캔 내역이 없습니다."
                    self.lb_Empty.isHidden = false
                    self.stv_Data.isHidden = true
                } else {
                    self.lb_Empty.isHidden = true
                    self.stv_Data.isHidden = false
                }

            } else {
                self.btn_Confirm.isHidden = true
                
                self.SSItems.removeAll()
                self.GMItems.removeAll()
                
                let SS = item.inboundAtOperationInventoryQuantityWithSkuMap?.성수DC
                let GM = item.inboundAtOperationInventoryQuantityWithSkuMap?.광명DC
                
                self.ssIds.removeAll()
                SS?.forEach({
                    $0.inventoryIds?.forEach({
                        self.ssIds.append($0)
                    })
                })

                self.gmIds.removeAll()
                GM?.forEach({
                    $0.inventoryIds?.forEach({
                        self.gmIds.append($0)
                    })
                })

//                self.ids = ssIds + gmIds
                
                if SS?.count ?? 0 <= 0 && GM?.count ?? 0 <= 0 {
                    //데이터 없음
                    switch self.mode {
                    case .order:
                        switch self.viewType {
                        case .fresh:
                            self.lb_Empty.text = "신선상품 발주 내역이 없습니다."
                        case .keep:
                            self.lb_Empty.text = "보관상품 발주 내역이 없습니다."
                        }
                    case .release:
                        switch self.viewType {
                        case .fresh:
                            self.lb_Empty.text = "신선상품 출고 내역이 없습니다."
                        case .keep:
                            self.lb_Empty.text = "보관상품 출고 내역이 없습니다."
                        }
                    case .scan:()
                    }
                    self.lb_Empty.isHidden = false
                    self.stv_Data.isHidden = true
                } else {
                    if self.mode == .order {
                        self.btn_Confirm.text = "발주 내역 확인하기"
                        self.btn_Confirm.image = nil
                        self.btn_Confirm.textColor = .white
                        self.btn_Confirm.backgroundColor = UIColor(hex: 0x18a0fb)
                        self.btn_Confirm.isUserInteractionEnabled = true
                        self.btn_Confirm.isHidden = false
                    }
                    self.lb_Empty.isHidden = true
                    self.stv_Data.isHidden = false
                }
                
                if item.orderStatus == "CONFIRMED" {
                    if self.mode == .order {
                        //확인
                        self.btn_Confirm.text = "발주 내역 확인완료"
                        self.btn_Confirm.image = UIImage(named: "btnConfirmGr")
                        self.btn_Confirm.textColor = UIColor(hex: 0x9e9e9e)
                        self.btn_Confirm.backgroundColor = UIColor(hex: 0xebebeb)
                        self.btn_Confirm.isUserInteractionEnabled = false
                        self.btn_Confirm.isHidden = false
                    } else if self.mode == .release {
    //                    self.btn_Confirm.text = "출고 QR 스캔 시작하기"
    //                    self.btn_Confirm.image = nil
    //                    self.btn_Confirm.textColor = .white
    //                    self.btn_Confirm.backgroundColor = UIColor(hex: 0x18a0fb)
    //                    self.btn_Confirm.isUserInteractionEnabled = true
    //                    self.btn_Confirm.isHidden = false
                    }
                } else if item.orderStatus == "OUTBOUND" {
                    //출고
                    
                }
                
                let ssCount = (SS?.compactMap({ $0.purchaseQuantity }).reduce(0) { $0 + $1 }) ?? 0
                let ssScanCount = (SS?.compactMap({ $0.currentScannedQuantity }).reduce(0) { $0 + $1 }) ?? 0
                self.SSItems.append(NDCommListItem.init(listType: .space(height: 18)))
                self.SSItems.append(NDCommListItem.init(listType: .timeHeader, title: HSTR("성수 DC"), count: ssCount, scanCount: ssScanCount))
                self.SSItems.append(NDCommListItem.init(listType: .space(height: 12)))

                let gmCount = (GM?.compactMap({ $0.purchaseQuantity }).reduce(0) { $0 + $1 }) ?? 0
                let gmScanCount = (GM?.compactMap({ $0.currentScannedQuantity }).reduce(0) { $0 + $1 }) ?? 0
                self.GMItems.append(NDCommListItem.init(listType: .space(height: 18)))
                self.GMItems.append(NDCommListItem.init(listType: .timeHeader, title: HSTR("광명 DC"), count: gmCount, scanCount: gmScanCount))
                self.GMItems.append(NDCommListItem.init(listType: .space(height: 12)))

                let totalCnt = ssCount + gmCount
                self.lb_TotalCount.text = totalCnt.toString().toDecimalString() + "건"
                
                
                switch self.viewType {
                case .fresh:()
                    self.SSItems.append(contentsOf: self.getFreshData(array: SS))
                    self.GMItems.append(contentsOf: self.getFreshData(array: GM))

    //                //스캔 테스트 코드
    //                self.SSItems.append(NDCommListItem.init(listType: .button(title: HSTR("출고 QR 스캔 시작하기"))))
    //                self.GMItems.append(NDCommListItem.init(listType: .button(title: HSTR("출고 QR 스캔 시작하기"))))
    //                self.lb_Empty.isHidden = true
    //                self.stv_Data.isHidden = false
    //                //////////////

                case .keep:
                    self.SSItems.append(contentsOf: self.getKeepData(array: SS))
                    self.GMItems.append(contentsOf: self.getKeepData(array: GM))
                }
                
                
                if self.mode == .release {
                    var status = "총 출고예정 수량"
//                    let ssScanFinish = self.SSItems.filter({ $0.isFinish })
//                    let gmScanFinish = self.GMItems.filter({ $0.isFinish })
                    if (ssCount > 0 || gmCount > 0) && (ssCount == ssScanCount && gmCount == gmScanCount) {
//                    if ssScanFinish.count > 0 && gmScanFinish.count > 0 {
                        status = "총 출고 수량"
                    }
                    self.v_TotalCount.isHidden = false
                    self.lb_TotalCountTitle.text = status
                    let totalScanCnt = ssScanCount + gmScanCount
                    self.lb_TotalCount.text = totalScanCnt.toString().toDecimalString() + "/" +  totalCnt.toString().toDecimalString() + "건"

                    if item.orderStatus == "OUTBOUND" {
                        self.btn_Confirm.isHidden = true
                    } else {
                        if ((ssCount == 0) || (ssCount > 0 && ssCount == ssScanCount)) && ((gmCount == 0) || (gmCount > 0 && gmCount == gmScanCount)) {
                            self.btn_Confirm.text = "출고하기"
                            self.btn_Confirm.image = nil
                            self.btn_Confirm.textColor = .white
                            self.btn_Confirm.backgroundColor = UIColor(hex: 0x18a0fb)
                            self.btn_Confirm.isUserInteractionEnabled = true
                            self.btn_Confirm.isHidden = false
                        }
                    }
                }
            }
            
            self.tbv_GM.reloadData()
            self.tbv_SS.reloadData()
            self.view.setNeedsLayout()
        }
    }

    func getFreshData(array: [NDOrder.InboundAtOperationInventoryQuantityWithSkuMap]?) -> [NDCommListItem] {
        var items: [NDCommListItem] = []
        var times = [[],[],[]]
        array?.forEach({
            if $0.inboundTime == "09시" {
                times[0].append((NDCommListItem.init(listType: (mode == .order ? .timeContents : .releaseContents), title:$0.skuName, count: $0.purchaseQuantity, contents: $0.skuName, scanCount: $0.currentScannedQuantity)))
            } else if $0.inboundTime == "13시" {
                times[1].append((NDCommListItem.init(listType: (mode == .order ? .timeContents : .releaseContents), title:$0.skuName, count: $0.purchaseQuantity, contents: $0.skuName, scanCount: $0.currentScannedQuantity)))
            } else if $0.inboundTime == "15시" {
                times[2].append((NDCommListItem.init(listType: (mode == .order ? .timeContents : .releaseContents), title:$0.skuName, count: $0.purchaseQuantity, contents: $0.skuName, scanCount: $0.currentScannedQuantity)))
            }
        })
        
        if times[0].count > 0 {
//            let totalScanCnt = times[0].compactMap({
//                let subItem = $0 as! NDCommListItem
//                return subItem.scanCount
//            }).reduce(0) { $0 + $1 }
            let totalnCnt = times[0].compactMap({
                let subItem = $0 as! NDCommListItem
                return subItem.count
            }).reduce(0) { $0 + $1 }
            items.append(NDCommListItem.init(listType: .timeSubHeader, title: "09시", count: totalnCnt, iconName: "icMorningS", color: UIColor(hex: 0xffa500)))
            items.append(NDCommListItem.init(listType: .space(height: 12)))
            times[0].forEach({
                items.append($0 as! NDCommListItem)
            })
            items.append(NDCommListItem.init(listType: .space(height: 6)))
        }
        if times[1].count > 0 {
            let totalnCnt = times[1].compactMap({
                let subItem = $0 as! NDCommListItem
                return subItem.count
            }).reduce(0) { $0 + $1 }
            items.append(NDCommListItem.init(listType: .timeSubHeader, title: "13시", count: totalnCnt, iconName: "icEveningS", color: UIColor(hex: 0xf86b3f)))
            items.append(NDCommListItem.init(listType: .space(height: 12)))
            times[1].forEach({
                items.append($0 as! NDCommListItem)
            })
            items.append(NDCommListItem.init(listType: .space(height: 6)))
        }
        if times[2].count > 0 {
            let totalnCnt = times[2].compactMap({
                let subItem = $0 as! NDCommListItem
                return subItem.count
            }).reduce(0) { $0 + $1 }
            items.append(NDCommListItem.init(listType: .timeSubHeader, title: "15시", count: totalnCnt, iconName: "icNightS", color: UIColor(hex: 0x7741bc)))
            items.append(NDCommListItem.init(listType: .space(height: 12)))
            times[2].forEach({
                items.append($0 as! NDCommListItem)
            })
            items.append(NDCommListItem.init(listType: .space(height: 6)))
        }
        
//        if array?.count ?? 0 <= 0 {
//            items.append(NDCommListItem.init(listType: .space(height: 7)))
//        }
        
        if self.mode == .release {
            let totalCnt = (array?.compactMap({ $0.purchaseQuantity ?? 0 }).reduce(0) { $0 + $1 }) ?? 0
            let scanCnt = (array?.compactMap({ $0.currentScannedQuantity ?? 0 }).reduce(0) { $0 + $1 }) ?? 0
            if totalCnt > 0 && totalCnt != scanCnt {
                items.append(NDCommListItem.init(listType: .button(title: HSTR("출고 QR 스캔 시작하기")), datas: array, dcId: array?[0].dcId))
                items.append(NDCommListItem.init(listType: .space(height: 18)))
            } else if totalCnt > 0 && totalCnt == scanCnt {
                items.append(NDCommListItem.init(listType: .button(title: HSTR("출고 QR 스캔 완료")), iconName: "btnConfirmGr", isFinish: true))
                items.append(NDCommListItem.init(listType: .space(height: 18)))
            }
        }
        
//        for i in 0..<(array?.count ?? 0) {
//            let obj = array?[i]
//            if (obj?.purchaseQuantity ?? 0) != obj?.currentScannedQuantity {
////            if obj?.purchaseQuantity != obj?.currentScannedQuantity {
//                items.append(NDCommListItem.init(listType: .button(title: HSTR("출고 QR 스캔 완료")), datas: array, dcId: obj?.dcId))
//                items.append(NDCommListItem.init(listType: .space(height: 18)))
//                break
//            }
//        }

        return items
    }
    
    func getKeepData(array: [NDOrder.InboundAtOperationInventoryQuantityWithSkuMap]?) -> [NDCommListItem] {
        var items: [NDCommListItem] = []
        array?.forEach({
            items.append(NDCommListItem.init(listType: (mode == .order ? .keepContents : .releaseContents), title: $0.expectedReceiptDate, count: $0.purchaseQuantity, contents: $0.skuName, status: $0.changeStatus?.code, data:$0, scanCount: $0.currentScannedQuantity))
            items.append(NDCommListItem.init(listType: .space(height: 8)))
        })
        if array?.count ?? 0 > 0 {
            items.append(NDCommListItem.init(listType: .space(height: 7)))
        }
        
        if self.mode == .release {
            let totalCnt = (array?.compactMap({ $0.purchaseQuantity ?? 0 }).reduce(0) { $0 + $1 }) ?? 0
            let scanCnt = (array?.compactMap({ $0.currentScannedQuantity ?? 0 }).reduce(0) { $0 + $1 }) ?? 0
            if totalCnt > 0 && totalCnt != scanCnt {
                items.append(NDCommListItem.init(listType: .button(title: HSTR("출고 QR 스캔 시작하기")), datas: array, dcId: array?[0].dcId))
                items.append(NDCommListItem.init(listType: .space(height: 18)))
            } else if totalCnt > 0 && totalCnt == scanCnt {
                items.append(NDCommListItem.init(listType: .button(title: HSTR("출고 QR 스캔 완료")), iconName: "btnConfirmGr", isFinish: true))
                items.append(NDCommListItem.init(listType: .space(height: 18)))
            }
        }

        return items
    }

    
    @IBAction func goConfirm(_ sender: Any) {
        switch mode {
        case .order:
            var actions: [UMAction] = []
            actions.append(UMAction(title: HSTR("comm.yes"), style: .confirm, handler: {
                var sender = MRest.Sender(path: .orderStatus, method: .put)
                switch self.sortType {
                case .all:
                    sender.parameters[Keys.inventoryIds] = self.ssIds + self.gmIds
                case .SS:
                    sender.parameters[Keys.inventoryIds] = self.ssIds
                case .GM:
                    sender.parameters[Keys.inventoryIds] = self.gmIds
                }
                sender.parameters[Keys.inventoryOrderStatus] = "CONFIRMED"
                MRest.shared.request(sender) { (resp: MRest.Resp<NABase>) in
                    guard resp.code == .success else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            PPAlert.present(inVC: self, title: resp.message)
                        }
                        return
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }))
            actions.append(UMAction(title: HSTR("comm.no"), style: .cancel, handler: {
            }))
            PPAlert.present(inVC: self, title: HSTR("발주내역을 모두 확인하셨나요?"), actions: actions)
        case .release:
            var actions: [UMAction] = []
            actions.append(UMAction(title: HSTR("comm.yes"), style: .confirm, handler: {
                var sender = MRest.Sender(path: .orderStatus, method: .put)
                switch self.sortType {
                case .all:
                    sender.parameters[Keys.inventoryIds] = self.ssIds + self.gmIds
                case .SS:
                    sender.parameters[Keys.inventoryIds] = self.ssIds
                case .GM:
                    sender.parameters[Keys.inventoryIds] = self.gmIds
                }
                sender.parameters[Keys.inventoryOrderStatus] = "OUTBOUND"
                MRest.shared.request(sender) { (resp: MRest.Resp<NABase>) in
                    guard resp.code == .success else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            PPAlert.present(inVC: self, title: resp.message)
                        }
                        return
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }))
            actions.append(UMAction(title: HSTR("comm.no"), style: .cancel, handler: {
            }))
            PPAlert.present(inVC: self, title: HSTR("출고하시겠습니까?"), actions: actions)
        default:()
        }
    }
    
    @IBAction func goShowCalendar(_ sender: Any) {
        let vc = CalendarViewController.instantiate()
        vc.mode = .single
        vc.completeHandler = { [weak self] start, end in
            if let start = start {
                self?.orgDate = start
                var dateString = start.string(fmt: "MM.dd(\(start.getWeakDay()))")
                if start.isToday {
                    dateString += " " + HSTR("comm.today")
                }
                self?.selectDate = dateString
                self?.lb_Date.text = self?.selectDate
            }
            self?.reload()
        }
        
        present(vc, animated: true, completion: nil)
    }

    @IBAction func goShowSortType(_ sender: Any) {
        let vc = BottomPopUpViewController.instantiate()
        vc.title = "DC별 보기"
        vc.selectType = sortType
        vc.items = [BottomPopUpViewController.Item(type: SortType.all),
                    BottomPopUpViewController.Item(type: SortType.SS),
                    BottomPopUpViewController.Item(type: SortType.GM)]
        vc.completeHandler = { [weak self] sortType in
            self?.sortType = sortType
        }
        present(vc, animated: true, completion: nil)
    }
    
}

extension OrderDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbv_SS {
            return SSItems.count
        }
        return GMItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var item: NDCommListItem?
        if tableView == tbv_SS {
            item = SSItems[indexPath.row]
        } else {
            item = GMItems[indexPath.row]
        }
        
        if let item = item {
            switch item.listType {
            case .timeHeader:
                let cell: ListTimeHeaderCell = tableView.dequeueReusableCell(for: indexPath)
                cell.lb_Title.text = item.title
                if mode == .release || mode == .scan {
                    cell.lb_Count.text = (item.scanCount?.toString().toDecimalString() ?? "0") + "/" + item.count.toString().toDecimalString() + HSTR("건")
                } else {
                    cell.lb_Count.text = item.count.toString().toDecimalString() + HSTR("건")
                }
                return cell
            case .timeSubHeader:
                let cell: ListTimeSubHeaderCell = tableView.dequeueReusableCell(for: indexPath)
                cell.iv_Icon.image = UIImage(named: item.iconName ?? "")
                cell.lb_Title.text = item.title
                cell.lb_Count.text = item.count.toString().toDecimalString() + HSTR("건")
                cell.v_Bg.backgroundColor = item.color
                cell.lb_Title.textColor = item.color
                cell.lb_Count.textColor = item.color
                return cell
            case .timeContents:
                let cell: ListTimeContentsCell = tableView.dequeueReusableCell(for: indexPath)
                cell.lb_Title.text = item.title
                cell.lb_Count.text = item.count.toString().toDecimalString() + HSTR("건")
                return cell
            case .space(let height):
                let cell: SpaceCell = tableView.dequeueReusableCell(for: indexPath)
                cell.lc_Space.constant = height
                return cell
            case .keepContents:
                let cell: ListKeepContentsCell = tableView.dequeueReusableCell(for: indexPath)
                var changeDate: Date?
                if let title = item.title, let date = title.toDate(fmt: "yyyy.MM.dd HH:mm:ss") {
                    var maxId = 0
                    var after = ""
                    item.data?.inboundReceiptDateChangeHistories?.forEach({
                        if let id = $0.id {
                            if id > maxId && $0.status ?? "" == "CONFIRMED" {
                                maxId = id
                                after = $0.afterReceiptDate ?? ""
                            }
                        }
                    })
                    if after.count > 0 {
                        if let afterDate = after.toDate(fmt: "yyyy-MM-dd HH:mm:ss") {
                            changeDate = afterDate
                            cell.lb_Title.text = afterDate.string(fmt: "yyyy.MM.dd") + "(\(afterDate.getWeakDay()))" + " 도착"
                        }
                    } else {
                        cell.lb_Title.text = date.string(fmt: "yyyy.MM.dd") + "(\(date.getWeakDay()))" + " 도착"
                    }
                } else {
                    cell.lb_Title.text = ""
                }
                cell.lb_Count.text = item.count.toString().toDecimalString() + HSTR("건")
                cell.lb_Contents.text = item.contents
                
                switch item.status {
                case .CHANGABLE:
                    cell.iv_Icon.image = UIImage(named: "btnOrderDate01")
                    cell.btn_Action.onTap {
                        //도착일 변경
                        if let title = item.title, let date = title.toDate(fmt: "yyyy.MM.dd HH:mm:ss") {
                            let vc = CalendarViewController.instantiate()
                            if let changeDate = changeDate {
                                //도착일을 변경 한 경우 변경한 도착일이 나오게
                                vc.mode = .change(oldDate: changeDate, ids:item.data?.inventoryIds)
                            } else {
                                vc.mode = .change(oldDate: date, ids:item.data?.inventoryIds)
                            }
                            vc.completeHandler = { [weak self] start, end in
                                var sender = MRest.Sender(path: .changeDate)
                                sender.parameters[Keys.operationInventoryIdList] = item.data?.inventoryIds
                                sender.parameters[Keys.requestDate] = start!.string(fmt: "yyyy-MM-dd")
                                sender.parameters[Keys.reason] = "도착일 변경"
                                MRest.shared.request(sender) { (resp: MRest.Resp<NABase>) in
                                    guard resp.code == .success else {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                            PPAlert.present(inVC: self, title: resp.message)
                                        }
                                        return
                                    }
                                    print(resp.object)
//                                    guard let item = resp.object.row else { return }
                                }
                            }
                            let navi = UMNavigationController(rootViewController: vc)
                            navi.isNavigationBarHidden = true
                            navi.modalPresentationStyle = .fullScreen
                            self.present(navi, animated: true, completion: nil)
                        }
                    }
                case .CHANGING:
                    cell.iv_Icon.image = UIImage(named: "btnOrderDate02")
                    cell.btn_Action.onTap {
                        //도착일 변경 진행 중
                        var maxId = 0
                        var before = ""
                        var after = ""
                        item.data?.inboundReceiptDateChangeHistories?.forEach({
                            if let id = $0.id {
                                if id > maxId && $0.status ?? "" == item.status?.rawValue {
                                    maxId = id
                                    before = $0.beforeReceiptDate ?? ""
                                    after = $0.afterReceiptDate ?? ""
                                }
                            }
                        })
                        
                        var contents = ""
                        if let beforeDate = before.toDate(fmt: "yyyy-MM-dd") {
                            contents = "기존일: " + beforeDate.string(fmt: "yyyy년 MM월 dd일") + "(\(beforeDate.getWeakDay()))"
                            contents += "\n"
                        }
                        if let afterDate = after.toDate(fmt: "yyyy-MM-dd") {
                            contents = "변경요청일: " + afterDate.string(fmt: "yyyy년 MM월 dd일") + "(\(afterDate.getWeakDay()))"
                            contents += "\n\n"
                        }
                        contents += "담당자 확인 후 변경이 완료됩니다."
                        
                        var actions: [UMAction] = []
                        actions.append(UMAction(title: "네, 알겠습니다", style: .confirm, handler: {
                        }))
                        PPAlert.present(inVC: self, title: HSTR("도착일 변경 진행중입니다."), message: contents, actions: actions)
                    }
                case .REJECT:
                    cell.iv_Icon.image = UIImage(named: "btnOrderDate03")
                    cell.btn_Action.onTap {
                        //반려
                        var maxId = 0
                        var poupContents = ""
                        item.data?.inboundReceiptDateChangeHistories?.forEach({
                            if let id = $0.id {
                                if id > maxId && $0.status ?? "" == item.status?.rawValue {
                                    maxId = id
                                    poupContents = $0.companyReason ?? ""
                                }
                            }
                        })
                        var actions: [UMAction] = []
                        actions.append(UMAction(title: "문의하기", style: .confirm, handler: {
                            let vc = AskViewController.instantiate()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }))
                        actions.append(UMAction(title: HSTR("comm.yes"), style: .cancel, handler: {
                            
                        }))
                        PPAlert.present(inVC: self, title: HSTR("도착일 변경이 반려되었습니다."), message: poupContents, actions: actions)
                    }
                default:()
                }
                return cell
            case .releaseContents:
                let cell: ListReleaseCell = tableView.dequeueReusableCell(for: indexPath)
                cell.lb_Title.text = item.contents
//                let cnt = item.data?.purchaseQuantity ?? 0
//                let scanCnt = item.data?.currentScannedQuantity ?? 0
//                if cnt > 0 && cnt == scanCnt {
//                    //스캔 완료시
//                    cell.v_CountBg.backgroundColor = UIColor(hex: 0x18a0fb)
//                } else {
//                    //스캔 미완료시
//                    cell.v_CountBg.backgroundColor = UIColor(hex: 0x9E9E9E)
//                }
                let cnt = item.count
                let scanCnt = item.scanCount ?? 0
                if cnt > 0 && cnt == scanCnt {
                    //스캔 완료시
                    cell.v_CountBg.backgroundColor = UIColor(hex: 0x18a0fb)
                } else {
                    //스캔 미완료시
                    cell.v_CountBg.backgroundColor = UIColor(hex: 0x9E9E9E)
                }
                cell.lb_Count.text = (item.scanCount?.toString() ?? "") + "/" + item.count.toString() + HSTR("건")
                return cell
            case .button(let title):
                let cell: ListButtonCell = tableView.dequeueReusableCell(for: indexPath)
                cell.btn.text = title
                if item.isFinish {
                    cell.btn.backgroundColor = UIColor(hex: 0xebebeb)
                    cell.btn.image = UIImage(named: item.iconName ?? "")
                    cell.btn.textColor = UIColor(hex: 0x9e9e9e)
                    cell.btn.isUserInteractionEnabled = false
                } else {
                    cell.btn.backgroundColor = UIColor(hex: 0x18a0fb)
                    cell.btn.image = nil
                    cell.btn.textColor = .white
                    cell.btn.isUserInteractionEnabled = true
                }
                cell.btn.onTap {
                    if self.mode == .release {
                        let vc = QRReaderViewController.instantiate()
                        vc.items = item.datas
                        vc.dcId = item.dcId
                        vc.orgDate = self.orgDate
                        let navi = UMNavigationController(rootViewController: vc)
                        navi.modalPresentationStyle = .fullScreen
    //                    let vc = QRReaderViewController.instantiate()
                        vc.completeHandler = { [weak self] code in
                            print(code)
                        }
                        self.present(navi, animated: true, completion: nil)
                    }
                }
                return cell
            default:()
            }
        }

        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
