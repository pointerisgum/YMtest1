//
//  ReleaseViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/02.
//

import UIKit

extension ReleaseViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Release", bundle: nil)
}

class ReleaseViewController: UMViewController {

    @IBOutlet weak var lb_Date: UILabel!
    @IBOutlet weak var tbv_Fresh: UITableView!
    @IBOutlet weak var tbv_Keep: UITableView!
    @IBOutlet weak var iv_FreshTypeIcon: UIImageView! {
        didSet {
            iv_FreshTypeIcon.isHidden = true
        }
    }
    @IBOutlet weak var iv_KeepTypeIcon: UIImageView! {
        didSet {
            iv_KeepTypeIcon.isHidden = true
        }
    }
    @IBOutlet weak var btn_FreshDetail: UIButton! {
        didSet {
            btn_FreshDetail.isHidden = true
        }
    }
    @IBOutlet weak var btn_KeepDetail: UIButton! {
        didSet {
            btn_KeepDetail.isHidden = true
        }
    }
    
    @IBOutlet weak var lc_FreshHeight: NSLayoutConstraint!
    @IBOutlet weak var lc_KeepHeight: NSLayoutConstraint!

    var freshItems: [NDCommListItem] = []
    var keepItems: [NDCommListItem] = []
    var startDate = Date() {
        didSet {
            var dateString = startDate.string(fmt: "MM.dd(\(startDate.getWeakDay()))")
            if startDate.isToday {
                dateString += " " + HSTR("comm.today")
            }
            lb_Date.text = dateString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//#if DEBUG
//        let testDate = "2022-01-19"
//        startDate = testDate.toDate(fmt: "yyyy-MM-dd")!
//#endif
        
        startDate = Date()

        tbv_Fresh.register(type: ListHeaderCell.self)
        tbv_Fresh.register(type: ListOrderCell.self)
        tbv_Fresh.register(type: ListButtonCell.self)
        
        tbv_Keep.register(type: ListHeaderCell.self)
        tbv_Keep.register(type: ListOrderCell.self)
        tbv_Keep.register(type: ListButtonCell.self)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        lc_FreshHeight.constant = tbv_Fresh.contentSize.height
        lc_KeepHeight.constant = tbv_Keep.contentSize.height
    }

    func reload() {
        var sender = MRest.Sender(path: .release, method: .get)
        sender.customUrl = PPCST.Rest.baseURL + PPCST.Rest.apiUri + MRest.Path.release.rawValue +
        "?\(Keys.receiptDate)=\(startDate.string(fmt: "yyyy-MM-dd"))"

        MRest.shared.request(sender) { (resp: MRest.Resp<NARow<NDHome.OperationInventoryCountResponse>>) in
            guard resp.code == .success else {
                return
            }

            guard let item = resp.object.row else { return }

            //신선상품 발주
            self.freshItems.removeAll()
            let dailyCountMap: Dictionary? = resp.dic?["dailyCountMap"] as? Dictionary<String, Int>
            
            var totalFreshCount = 0
            dailyCountMap?.keys.forEach {
                let count = dailyCountMap?[$0] ?? 0
                totalFreshCount += count
                self.freshItems.append(NDCommListItem.init(listType: .contents, title: $0, count: count))
            }
            self.freshItems.insert(NDCommListItem.init(listType: .header, title: HSTR("출고예정 수량"), count: totalFreshCount), at: 0)
            self.btn_FreshDetail.isHidden = totalFreshCount <= 0
            
            if item.dailyOrderStatus == "OUTBOUND" {
                self.freshItems.append(NDCommListItem.init(listType: .button(title: HSTR("출고 QR 스캔 완료")), iconName: "btnConfirmGr", isFinish: true))
            } else if item.dailyOrderStatus == "CONFIRMED" {
                self.freshItems.append(NDCommListItem.init(listType: .button(title: HSTR("출고 QR 스캔 시작하기"))))
            }

            if totalFreshCount > 0 {
                if item.dailyOrderType == "예상" {
                    self.iv_FreshTypeIcon.image = UIImage(named: "badgeOrder01")
                    self.iv_FreshTypeIcon.isHidden = false
                } else if item.dailyOrderType == "확정" {
                    self.iv_FreshTypeIcon.image = UIImage(named: "badgeOrder02")
                    self.iv_FreshTypeIcon.isHidden = false
                } else {
                    self.iv_FreshTypeIcon.isHidden = true
                }
            } else {
                self.iv_FreshTypeIcon.isHidden = true
            }
            self.tbv_Fresh.reloadData()
            
            

            //보관상품 발주
            self.keepItems.removeAll()
            let unDailyCountMap: Dictionary? = resp.dic?["unDailyCountMap"] as? Dictionary<String, Int>
            
            var totalKeepCount = 0
            unDailyCountMap?.keys.forEach {
                let count = unDailyCountMap?[$0] ?? 0
                totalKeepCount += count
                self.keepItems.append(NDCommListItem.init(listType: .contents, title: $0, count: count))
            }
            self.keepItems.insert(NDCommListItem.init(listType: .header, title: HSTR("출고예정 수량"), count: totalKeepCount), at: 0)
            
            if item.unDailyOrderStatus == "OUTBOUND" {
                self.keepItems.append(NDCommListItem.init(listType: .button(title: HSTR("출고 QR 스캔 완료")), iconName: "btnConfirmGr", isFinish: true))
            } else if item.unDailyOrderStatus == "CONFIRMED" {
                self.keepItems.append(NDCommListItem.init(listType: .button(title: HSTR("출고 QR 스캔 시작하기"))))
            }
//            if totalKeepCount > 0 {
//                //보관상품이 있는 경우엔 항상 확정 라벨 표시와 발주내역확인 버튼 노출
////                self.iv_KeepTypeIcon.image = UIImage(named: "badgeOrder01")
////                self.iv_KeepTypeIcon.isHidden = false
//                self.keepItems.append(NDCommListItem.init(listType: .button(title: HSTR("출고 QR 스캔 시작하기"))))
//            } else {
//                self.iv_KeepTypeIcon.isHidden = true
//            }
            
            self.btn_KeepDetail.isHidden = totalKeepCount <= 0

            self.view.setNeedsLayout()
            self.tbv_Keep.reloadData()

        }
    }
    
    @IBAction func goShowFreshDetail(_ sender: Any?) {
        let vc = OrderDetailViewController.instantiate()
        vc.orgDate = self.startDate
        vc.selectDate = self.lb_Date.text
        vc.mode = .release
        vc.viewType = .fresh
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goShowKeepDetail(_ sender: Any?) {
        let vc = OrderDetailViewController.instantiate()
        vc.orgDate = self.startDate
        vc.selectDate = self.lb_Date.text
        vc.mode = .release
        vc.viewType = .keep
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goShowCalendar(_ sender: Any) {
        let vc = CalendarViewController.instantiate()
        vc.mode = .single
        vc.completeHandler = { [weak self] start, end in
            if let start = start {
                self?.startDate = start
            }
            self?.reload()
        }
        
        present(vc, animated: true, completion: nil)
    }
    
//    @IBAction func goShowWeekOrder(_ sender: Any) {
//        let vc = WeekReleaseViewController.instantiate()
//        navigationController?.pushViewController(vc, animated: true)
//    }
}

extension ReleaseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbv_Fresh {
            return freshItems.count
        } else if tableView == tbv_Keep {
            return keepItems.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var item: NDCommListItem?
        if tableView == tbv_Fresh {
            item = freshItems[indexPath.row]
        } else if tableView == tbv_Keep {
            item = keepItems[indexPath.row]
        }
        
        if let item = item {
            switch item.listType {
            case .header:
                let cell: ListHeaderCell = tableView.dequeueReusableCell(for: indexPath)
                if freshItems.count == 1 {
                    cell.lc_Bottom.constant = 0
                } else {
                    cell.lc_Bottom.constant = 7
                }
                cell.lb_Title.text = item.title
                cell.lb_Count.text = item.count.toString().toDecimalString() + HSTR("건")
                cell.lb_Count.textColor = UIColor.color_18a0fb
                return cell
            case .contents:
                let cell: ListOrderCell = tableView.dequeueReusableCell(for: indexPath)
                cell.lb_Title.text = item.title
                cell.lb_Count.text = item.count.toString().toDecimalString() + HSTR("건")
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
                    if tableView == self.tbv_Fresh {
                        self.goShowFreshDetail(nil)
                    } else if tableView == self.tbv_Keep {
                        self.goShowKeepDetail(nil)
                    }
                }
                return cell
            default:()
            }
        }
        

//        if tableView == tbv_Fresh {
//            let item = freshItems[indexPath.row]
//            switch item.listType {
//            case .header:
//                let cell: ListHeaderCell = tableView.dequeueReusableCell(for: indexPath)
//                if freshItems.count == 1 {
//                    cell.lc_Bottom.constant = 0
//                } else {
//                    cell.lc_Bottom.constant = 7
//                }
//                cell.lb_Title.text = item.title
//                cell.lb_Count.text = item.count.toString().toDecimalString() + HSTR("건")
//                cell.lb_Count.textColor = UIColor.color_18a0fb
//                return cell
//            case .contents:
//                let cell: ListOrderCell = tableView.dequeueReusableCell(for: indexPath)
//                cell.lb_Title.text = item.title
//                cell.lb_Count.text = item.count.toString().toDecimalString() + HSTR("건")
//                return cell
//            case .button(let title):
//                let cell: ListButtonCell = tableView.dequeueReusableCell(for: indexPath)
//                cell.btn.text = title
//                cell.btn.onTap {
//                    print("111")
//                }
//                return cell
//            default:()
//            }
//        } else if tableView == tbv_Keep {
//            let item = keepItems[indexPath.row]
//            switch item.listType {
//            case .header:
//                let cell: ListHeaderCell = tableView.dequeueReusableCell(for: indexPath)
//                if freshItems.count == 1 {
//                    cell.lc_Bottom.constant = 0
//                } else {
//                    cell.lc_Bottom.constant = 7
//                }
//                cell.lb_Title.text = item.title
//                cell.lb_Count.text = item.count.toString().toDecimalString() + HSTR("건")
//                cell.lb_Count.textColor = UIColor.color_18a0fb
//                return cell
//            case .contents:
//                let cell: ListOrderCell = tableView.dequeueReusableCell(for: indexPath)
//                cell.lb_Title.text = item.title
//                cell.lb_Count.text = item.count.toString().toDecimalString() + HSTR("건")
//                return cell
//            case .button(let title):
//                let cell: ListButtonCell = tableView.dequeueReusableCell(for: indexPath)
//                cell.btn.text = title
//                cell.btn.onTap {
//                    print("111")
//                }
//                return cell
//            default:()
//            }
//        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let item = alertItems[indexPath.row]
//        self.view.setNeedsLayout()
        
//        let vc = CalendarViewController.instantiate()
//        present(vc, animated: true, completion: nil)
//        let vc = Calendar2ViewController.instantiate()
//        present(vc, animated: true, completion: nil)

        

    }
}
/*
 @IBAction func goShowBottomPopUp(_ sender: Any) {
     let vc = BottomPopUpViewController.instantiate()
     vc.title = "DC별 보기"
     vc.items = [BottomPopUpViewController.Item(title: "성수DC"),
                 BottomPopUpViewController.Item(title: "광명DC"),
                 BottomPopUpViewController.Item(title: HSTR("comm.all"), selected: true)]
     vc.completeHandler = { [weak self] selectItem in
         print(selectItem.title)
     }
     present(vc, animated: true, completion: nil)
 }
 */
