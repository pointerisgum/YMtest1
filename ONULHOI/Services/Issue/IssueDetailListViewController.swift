//
//  IssueDetailListViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/09.
//

import UIKit

extension IssueDetailListViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Issue", bundle: nil)
}

class IssueDetailListViewController: UMViewController {
    
    @IBOutlet weak var lb_Title: UILabel!
    @IBOutlet weak var lb_SelectDate: UILabel!
    @IBOutlet weak var tbv_List: UITableView!
    
    var naviTitle: String?
    var type: IssueType!
    var startDate: Date!
    var endDate: Date!
    var items: [NDIssueDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lb_Title.text = naviTitle
        tbv_List.register(type: IssuDetailDelayHeaderView.self)
        
        reload()
    }
    
    func reload() {
        lb_SelectDate.text = BalanceViewController.getStartEndDateString(start: startDate, end: endDate)

        var sender = MRest.Sender(path: .issuesInboundInfosDetail, method: .get)
//        sender.parameters[Keys.Date.fromDate] = startDate
//        sender.parameters[Keys.Date.toDate] = endDate
//        sender.parameters[Keys.reason] = type.rawValue
        
        sender.customUrl = PPCST.Rest.baseURL + PPCST.Rest.apiUri + MRest.Path.issuesInboundInfosDetail.rawValue +
        "?\(Keys.Date.fromDate)=\(startDate.string(fmt: "yyyy-MM-dd"))" +
        "&\(Keys.Date.toDate)=\(endDate.string(fmt: "yyyy-MM-dd"))" +
        "&\(Keys.reason)=\(type.rawValue)"

        MRest.shared.request(sender) { (resp: MRest.Resp<NARows<NDIssueDetail>>) in
            guard resp.code == .success else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    PPAlert.present(inVC: self, title: resp.message)
                }
                return
            }

            self.items = resp.object.rows
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

extension IssueDetailListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].serialNumber?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell: IssuDetailDelayHeaderView? = tableView.dequeueReusableHeaderFooterView()
        let item = items[section]
        let date = item.receiptDate?.toDate(fmt: "yyyy-MM-dd")
        if let date = date {
            headerCell?.lb_Date.text = date.string(fmt: "MM.dd(\(date.getWeakDay()))")
        } else {
            headerCell?.lb_Date.text = ""
        }
        return headerCell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = items[indexPath.section].serialNumber?[indexPath.row]
        let cell: IssueDetailListCell = tableView.dequeueReusableCell(for: indexPath)
        cell.lb_Title.text = title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let title = items[indexPath.section].serialNumber?[indexPath.row]

        let vc = IssueDetailListFileViewController.instantiate()
        vc.naviTitle = title
        navigationController?.pushViewController(vc, animated: true)
    }
}
