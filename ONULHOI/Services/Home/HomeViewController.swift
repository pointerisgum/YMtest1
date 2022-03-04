//
//  HomeViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/02.
//

import UIKit
import Alamofire

extension HomeViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Home", bundle: nil)
}

class HomeViewController: UMViewController {

    @IBOutlet weak var v_AlertBg: UIView!
    @IBOutlet weak var v_BalanceBg: UIView!
    @IBOutlet weak var v_NotiBg: UIView!
    
    @IBOutlet weak var tbv_Alert: UITableView!
    @IBOutlet weak var tbv_Order: UITableView!
    @IBOutlet weak var tbv_Issue: UITableView!
    @IBOutlet weak var tbv_Noti: UITableView!

    @IBOutlet weak var lb_Date: UILabel!
    @IBOutlet weak var btn_Price: UIButton!
    
    var alertItems: [NDHome.Alert]? = [] {
        didSet {
            v_AlertBg.isHidden = alertItems?.count ?? 0 <= 0
            lc_AlertHeight.constant = CGFloat((alertItems?.count ?? 0) > 0 ? (alertItems?.count ?? 0) * 56 : 0)
//            self.view.setNeedsLayout()
        }
    }
    var orderItems: [NDCommListItem] = []
    var issueItems: [NDCommListItem] = []
    var notiItems: [String] = [] {
        didSet {
            v_NotiBg.isHidden = notiItems.count <= 0
            lc_NotiHeight.constant = CGFloat(notiItems.count * 34)
        }
    }
    var onceReload = false
    
    @IBOutlet weak var lc_AlertHeight: NSLayoutConstraint! {
        didSet {
            lc_AlertHeight.constant = 0
        }
    }
    @IBOutlet weak var lc_OrderHeight: NSLayoutConstraint!
    @IBOutlet weak var lc_IssueHeight: NSLayoutConstraint!
    @IBOutlet weak var lc_NotiHeight: NSLayoutConstraint! {
        didSet {
            lc_NotiHeight.constant = 0
        }
    }
    @IBOutlet weak var lb_CompanyName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //삭제
        v_NotiBg.isHidden = true
//        notiItems.append("공지사항 테스트 1")
//        notiItems.append("공지사항 테스트 2")
//        notiItems.append("공지사항 테스트 3")
//        notiItems.append("공지사항 테스트 4")
//        notiItems.append("공지사항 테스트 5")

        tbv_Order.register(type: ListHeaderCell.self)
        tbv_Order.register(type: ListOrderCell.self)
        tbv_Order.register(type: ListButtonCell.self)

        tbv_Issue.register(type: ListHeaderCell.self)
        tbv_Issue.register(type: ListOrderCell.self)
        tbv_Issue.register(type: ListButtonCell.self)

//        alertItems.append("매달 1-10일은 세금계산서 발행 기간 입니다.")
//        alertItems.append("노티 테스트 2")
//        alertItems.append("노티 테스트 3")
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.alertItems.insert("새로 추가 된 노티", at: 0)
//            self.tbv_Alert.beginUpdates()
//            self.tbv_Alert.insertRows(at: [IndexPath(row: 0, section: 0)], with: .middle)
//            self.tbv_Alert.endUpdates()
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        lc_OrderHeight.constant = tbv_Order.contentSize.height
        lc_IssueHeight.constant = tbv_Issue.contentSize.height
    }
    
    func reload() {
//        Alamofire.request("https://feature2.partner-api.onul-hoi.com/partner/api/v1_0/operation-companies/home",
//                   method: .get,
//                   parameters: nil,
//                   encoding: JSONEncoding.default,
//                   headers: ["Content-Type": "application/json; charset=utf-8",
//                             "x-onul-auth-token": "onulhoi",
//                             "Authorization": MData.shared.accessToken!])
//            .validate()
//            .responseJSON { response in
//                switch response.result {
//                case .success:
//                    if let data = response.data {
//                        print(data)
//                    }
//                case .failure(let error):
//                    return
//                }
//            }
//            .responseJSON(completionHandler: { resp in
//                
//            })

        
        
        let sender = MRest.Sender(path: .home, method: .get)
        MRest.shared.request(sender) { (resp: MRest.Resp<NARow<NDHome>>) in
            guard resp.code == .success else {
                return
            }

            guard let item = resp.object.row else { return }
            
            self.lb_CompanyName.text = item.name
            
            //임시 비밀번호 로긴 체크
            if item.temporaryPassword == true && self.onceReload == false {
                var actions: [UMAction] = []
                actions.append(UMAction(title: HSTR("네, 알겠습니다"), handler: {
                    let vc = ChangePwViewController.instantiate()
                    vc.mode = .temp
                    self.navigationController?.pushViewController(vc, animated: true)
                }))
                PPAlert.present(inVC: self, title: HSTR("임시비밀번호 로그인"), message: HSTR("안전한 사용을 위해 비밀번호 변경을 진행해 주세요."), actions: actions)
            }

            //얼렛
            self.alertItems = item.operationCompanyAlertsResponseList
            self.tbv_Alert.reloadData()

            //날짜
            let date = item.settlementMonth?.toDate(fmt: "yyyy-MM-dd")
            self.lb_Date.text = date?.string(fmt: "yyyy년 MM월")
            
            //정산금액
            var balancePrice = 0
            if let price = item.confirmedAmount {
                balancePrice = price
            } else if let price = item.predictTotalAmount {
                balancePrice = price
            }
            self.btn_Price.text = balancePrice.toString().toDecimalString() + HSTR("comm.won")
            

            //발주수량
            self.orderItems.removeAll()
            
            var totalOrderCount = 0
            if let totalCountForMain = item.operationInventoryCountResponse?.totalCountForMain {
                let mirror = Mirror(reflecting: totalCountForMain)
                for child in mirror.children {
                    if let name = child.label {
                        totalOrderCount += child.value as? Int ?? 0
                        self.orderItems.append(NDCommListItem.init(listType: .contents, title: name, count: child.value as? Int ))
                    }
                }
            }

            
//            let operationInventoryCountResponse: Dictionary? = resp.dic?["operationInventoryCountResponse"] as? Dictionary<String, Any>
//            let totalCountForMain = operationInventoryCountResponse?["totalCountForMain"] as? Dictionary<String, Int>
//
//            var totalOrderCount = 0
//            totalCountForMain?.keys.forEach {
//                totalOrderCount += totalCountForMain?[$0] ?? 0
////                item.operationInventoryCountResponse.totalCountForMain.append(NDHome.TotalCountForMain(name: $0, count: totalCountForMain?[$0]))
////                self.orderItems.append(NDCommListItem.init(listType: .contents, title: $0, count: totalCountForMain?[$0] ?? 0))
//            }
            self.orderItems.insert(NDCommListItem.init(listType: .header, title: HSTR("발주 수량"), count: totalOrderCount), at: 0)
            self.tbv_Order.reloadData()

            //이슈
            self.issueItems.removeAll()
            self.issueItems.append(NDCommListItem.init(listType: .header, title: HSTR("이슈"), count: item.issueCountsResponse?.totalIssueCounts ?? 0))
            item.issueCountsResponse?.reasonCounts?.forEach {
                self.issueItems.append(NDCommListItem.init(listType: .contents, title: $0.reason?.desc ?? "", count: $0.counts ?? 0))
            }
            self.tbv_Issue.reloadData()

            
            self.onceReload = true
            
//            if item.operationInventoryCountResponse.totalCountForMain.count > 0 {
//
//            } else {
//
//            }
            
        }

    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        print("viewDidLayoutSubviews")
//        lc_OrderHeight.constant = tbv_Order.contentSize.height
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func goBalance(_ sender: Any) {
        let vc = BalanceViewController.instantiate()
        vc.hidesBottomBarWhenPushed = true
        vc.backBtnHidden = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbv_Alert {
            return alertItems?.count ?? 0
        } else if tableView == tbv_Order {
            return orderItems.count
        } else if tableView == tbv_Issue {
            return issueItems.count
        } else if tableView == tbv_Noti {
            return notiItems.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbv_Alert {
            let item = alertItems?[indexPath.row]
            let cell: MainAlertCell = tableView.dequeueReusableCell(for: indexPath)
            cell.lb_Title.text = item?.message
            cell.btn_Close.onTap {
                let buttonPosition = cell.btn_Close.convert(CGPoint.zero, to: self.tbv_Alert)
                guard let btnIndexPath: IndexPath = self.tbv_Alert.indexPathForRow(at: buttonPosition) else {
                    return
                }
                
                let item = self.alertItems?[btnIndexPath.row]
                if let id = item?.id {
                    var sender: MRest.Sender!
                    sender = MRest.Sender(path: .alerts, method: .put)
                    sender.customUrl = PPCST.Rest.baseURL + PPCST.Rest.apiUri + MRest.Path.alerts.rawValue + "/" + id.toString()
                    MRest.shared.request(sender) { (resp: MRest.Resp<NABase>) in
                        guard resp.code == .success else {
                            PPAlert.present(inVC: self, title: resp.message)
                            return
                        }
                        self.alertItems?.remove(at: btnIndexPath.row)
                        self.tbv_Alert.beginUpdates()
                        self.tbv_Alert.deleteRows(at: [IndexPath(row: btnIndexPath.row, section: 0)], with: .middle)
                        self.tbv_Alert.endUpdates()
                    }
                }
            }
            return cell
        } else if tableView == tbv_Order {
            let item = orderItems[indexPath.row]
            switch item.listType {
            case .header:
                let cell: ListHeaderCell = tableView.dequeueReusableCell(for: indexPath)
                cell.lb_Title.text = item.title
                cell.lb_Count.text = item.count.toString().toDecimalString() + HSTR("건")
                cell.lb_Count.textColor = UIColor.color_18a0fb
                return cell
            case .contents:
                let cell: ListOrderCell = tableView.dequeueReusableCell(for: indexPath)
                cell.lb_Title.text = item.title
                cell.lb_Count.text = item.count.toString().toDecimalString() + HSTR("건")
                return cell
            default:()
            }
//            if indexPath.row == 0 {
//            } else if indexPath.row == 1 {
//            } else if indexPath.row == 2 {
//                let cell: ListOrderCell = tableView.dequeueReusableCell(for: indexPath)
//                return cell
//            } else if indexPath.row == 3 {
//                let cell: ListButtonCell = tableView.dequeueReusableCell(for: indexPath)
//                cell.btn.text = HSTR("발주내역")
//                return cell
//            }
        } else if tableView == tbv_Issue {
            let item = issueItems[indexPath.row]
            switch item.listType {
            case .header:
                let cell: ListHeaderCell = tableView.dequeueReusableCell(for: indexPath)
                cell.lb_Title.text = item.title
                cell.lb_Count.text = item.count.toString().toDecimalString() + HSTR("건")
                cell.lb_Count.textColor = UIColor.hexColor(0xff6057)!
                return cell
            case .contents:
                let cell: ListOrderCell = tableView.dequeueReusableCell(for: indexPath)
                cell.lb_Title.text = item.title
                cell.lb_Count.text = item.count.toString().toDecimalString() + HSTR("건")
                return cell
            default:()
            }

            
            
//            if indexPath.row == 0 {
//                let cell: ListHeaderCell = tableView.dequeueReusableCell(for: indexPath)
//                cell.lb_Title.text = HSTR("이슈")
//                cell.lb_Count.text = "31".toDecimalString() + HSTR("건")
//                cell.lb_Count.textColor = UIColor.hexColor(0xff6057)!
//                return cell
//            } else {
//                let cell: ListOrderCell = tableView.dequeueReusableCell(for: indexPath)
//                return cell
//            }
        } else if tableView == tbv_Noti {
            let item = notiItems[indexPath.row]
            let cell: HomeNotiCell = tableView.dequeueReusableCell(for: indexPath)
            cell.lb_Title.text = item
            return cell
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let item = alertItems[indexPath.row]
//        self.view.setNeedsLayout()
        
        if tableView == tbv_Alert {
            
        }
//        let vc = CalendarViewController.instantiate()
//        present(vc, animated: true, completion: nil)
//        let vc = Calendar2ViewController.instantiate()
//        present(vc, animated: true, completion: nil)
    }
}
