//
//  BalanceViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/02.
//

import UIKit

extension BalanceViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Balance", bundle: nil)
}

class BalanceViewController: UMViewController {

    @IBOutlet weak var btn_Back: UIButton!
    @IBOutlet weak var lb_SelectDate: UILabel!
    @IBOutlet weak var lb_TotalPrice: UILabel!
    @IBOutlet weak var lb_Bank: UILabel!
    @IBOutlet weak var tbv_List: UITableView!

    var backBtnHidden = true
    var startDate: Date!
    var endDate: Date!
    var items: [NDSettlement.DailySettlementResponse]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_Back.isHidden = backBtnHidden
        
        //현재 월의 시작과 끝을 기본값을 설정
        let defaultStart = Date().startOfMonth().string(fmt: "yyyy-MM-dd")
//        let defaultStart = "2021-01-01"
        startDate = defaultStart.toDate(fmt: "yyyy-MM-dd")
        
        let defaultEnd = Date().endOfMonth().string(fmt: "yyyy-MM-dd")
//        let defaultEnd = "2021-12-31"
        endDate = defaultEnd.toDate(fmt: "yyyy-MM-dd")

//        endDate = Date().endOfMonth().string(fmt: "yyyy-MM-dd")
//        startDate = "2021-01-01"
//        endDate = "2021-12-31"
        
        reload()

    }
    
    override func doOnceViewDidAppear() {
        super.doOnceViewDidAppear()
    }
    
    static func getStartEndDateString(start: Date, end: Date) -> String {
        let startMonth = String(format: "%02ld", start.month)
        let startDay = String(format: "%02ld", start.day)
        
        let endMonth = String(format: "%02ld", end.month)
        let endDay = String(format: "%02ld", end.day)
        
        if startMonth == endMonth && startDay == endDay {
            return start.string(fmt: "MM.dd(\(start.getWeakDay()))")
        } else {
            return String(format: startMonth + "." + startDay + "(\(start.getWeakDay()))" +
                                        " ~ " +
                                        endMonth + "." + endDay + "(\(end.getWeakDay()))")
        }
    }
    
    func reload() {
        
        lb_SelectDate.text = BalanceViewController.getStartEndDateString(start: startDate, end: endDate)
        
//        let startMonth = String(format: "%02ld", startDate.month)
//        let startDay = String(format: "%02ld", startDate.day)
//
//        let endMonth = String(format: "%02ld", endDate.month)
//        let endDay = String(format: "%02ld", endDate.day)
//
//        if startMonth == endMonth && startDay == endDay {
//            lb_SelectDate.text = startDate.string(fmt: "MM.dd(\(startDate.getWeakDay()))")
//        } else {
//            lb_SelectDate.text = String(format: startMonth + "." + startDay + "(\(startDate.getWeakDay()))" +
//                                        " ~ " +
//                                        endMonth + "." + endDay + "(\(endDate.getWeakDay()))")
//        }
        
        var sender = MRest.Sender(path: .settlement, method: .get)
        sender.customUrl = PPCST.Rest.baseURL + PPCST.Rest.apiUri + MRest.Path.settlement.rawValue +
        "?\(Keys.Date.fromDate)=\(startDate.string(fmt: "yyyy-MM-dd"))" +
        "&\(Keys.Date.toDate)=\(endDate.string(fmt: "yyyy-MM-dd"))"
        MRest.shared.request(sender) { (resp: MRest.Resp<NARow<NDSettlement>>) in
            guard resp.code == .success else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    PPAlert.present(inVC: self, title: resp.message)
                }
                self.lb_TotalPrice.text = HSTR("0원")
                self.lb_Bank.text = "-"
                self.items?.removeAll()
                self.tbv_List.scrollToTop()
                self.tbv_List.reloadData()
                return
            }

            guard let item = resp.object.row else { return }

            self.lb_TotalPrice.text = (item.expectedSettlementAmount?.demicalString() ?? "0") + "원"
            self.lb_Bank.text = item.bankInfo
            
            self.items = item.dailySettlementResponseList
            self.tbv_List.scrollToTop()
            self.tbv_List.reloadData()
        }
    }
    
    @IBAction func goShowCalendar(_ sender: Any) {
        let vc = CalendarViewController.instantiate()
        vc.mode = .multi
        vc.completeHandler = { [weak self] start, end in
            if let start = start {
                self?.startDate = start
                self?.endDate = start
            }
            if let end = end {
                self?.endDate = end
            }
            self?.reload()
        }
        
        present(vc, animated: true, completion: nil)
    }
}

extension BalanceViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BalanceListCell = tableView.dequeueReusableCell(for: indexPath)
        let item = items?[indexPath.row]
//        cell.lb_Date.text = item?.receiptDate
        let date = item?.receiptDate?.toDate(fmt: "yyyy-MM-dd")
        if let date = date {
            cell.lb_Date.text = date.string(fmt: "MM.dd(\(date.getWeakDay()))")
        }
        cell.lb_Price.text = (item?.dailySettlementSum?.demicalString() ?? "0") + "원"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = items?[indexPath.row]
        if let item = item {
            let vc = BalanceDetailViewController.instantiate()
            vc.item = item
            present(vc, animated: true, completion: nil)
        }
    }
}
