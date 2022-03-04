//
//  IssueViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/02.
//

import UIKit

extension IssueViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Issue", bundle: nil)
}

enum IssueType: String {
    case SHORT_QUANTITY     //입고수량 불일치
    case DELAY              //입고시간 지연
    case FAULTY             //품질이슈
    case CUSTOMER_COMPLAIN  //고객불만
}

class IssueViewController: UMViewController {

    @IBOutlet weak var tbv_List: UITableView!
    @IBOutlet weak var lb_SelectDate: UILabel!

    var items: [NDHome.ReasonCounts]?
    var startDate: Date!
    var endDate: Date!

    override func viewDidLoad() {
        super.viewDidLoad()

#if DEBUG
        //테스트
        let defaultStart = "2021-10-11"
        startDate = defaultStart.toDate(fmt: "yyyy-MM-dd")
        let defaultEnd = "2021-12-31"
        endDate = defaultEnd.toDate(fmt: "yyyy-MM-dd")
#else
        //오늘이 기본값
        startDate = Date()
        endDate = Date()
#endif
        
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
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

        var sender = MRest.Sender(path: .issuesSummary, method: .get)
//        sender.parameters[Keys.Date.fromDate] = startDate.string(fmt: "yyyy-MM-dd")
//        sender.parameters[Keys.Date.toDate] = endDate.string(fmt: "yyyy-MM-dd")
        sender.customUrl = PPCST.Rest.baseURL + PPCST.Rest.apiUri + MRest.Path.issuesSummary.rawValue +
        "?\(Keys.Date.fromDate)=\(startDate.string(fmt: "yyyy-MM-dd"))" +
        "&\(Keys.Date.toDate)=\(endDate.string(fmt: "yyyy-MM-dd"))"
        MRest.shared.request(sender) { (resp: MRest.Resp<NARow<NDHome.IssueCountsResponse>>) in
            guard resp.code == .success else {
                return
            }

            guard let item = resp.object.row else { return }
            
            self.items = item.reasonCounts
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

extension IssueViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items?[indexPath.row]
        let cell: IssueMainListCell = tableView.dequeueReusableCell(for: indexPath)
        cell.lb_Title.text = item?.reason?.desc
        cell.lb_Count.text = (item?.counts?.toString().toDecimalString() ?? "0") + HSTR("건")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items?[indexPath.row]

        switch item?.reason?.code {
        case IssueType.SHORT_QUANTITY.rawValue:
            let vc = IssueDetailDelayViewController.instantiate()
            vc.naviTitle = item?.reason?.desc
            vc.type = .SHORT_QUANTITY
            vc.startDate = startDate
            vc.endDate = endDate
            navigationController?.pushViewController(vc, animated: true)
        case IssueType.DELAY.rawValue:
            let vc = IssueDetailDelayViewController.instantiate()
            vc.naviTitle = item?.reason?.desc
            vc.type = .DELAY
            vc.startDate = startDate
            vc.endDate = endDate
            navigationController?.pushViewController(vc, animated: true)
        case IssueType.FAULTY.rawValue:
            let vc = IssueDetailListViewController.instantiate()
            vc.naviTitle = item?.reason?.desc
            vc.type = .FAULTY
            vc.startDate = startDate
            vc.endDate = endDate
            navigationController?.pushViewController(vc, animated: true)
        case IssueType.CUSTOMER_COMPLAIN.rawValue:
            let vc = IssueDetailListViewController.instantiate()
            vc.naviTitle = item?.reason?.desc
            vc.type = .CUSTOMER_COMPLAIN
            vc.startDate = startDate
            vc.endDate = endDate
            navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
}
