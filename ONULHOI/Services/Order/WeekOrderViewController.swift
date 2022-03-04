//
//  WeekOrderViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/13.
//

import UIKit

extension WeekOrderViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Order", bundle: nil)
}

class WeekOrderViewController: UMViewController {

    @IBOutlet weak var tbv_List: UITableView!

    var items: [NDWeekOrder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tbv_List.register(type: IssuDetailDelayHeaderView.self)
        
        reload()
    }
    
    func reload() {
        let sender = MRest.Sender(path: .weekOrder, method: .get)
        MRest.shared.request(sender) { (resp: MRest.Resp<NARows<NDWeekOrder>>) in
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
}

extension WeekOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].predictNextWeekList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 47
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell: IssuDetailDelayHeaderView? = tableView.dequeueReusableHeaderFooterView()
        headerCell?.lc_Top.constant = 19
        headerCell?.lc_Bottom.constant = 7
        headerCell?.lb_Date.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        headerCell?.lb_Date.textColor = .black
        
        let item = items[section]
        let date = item.expectedReceiptDate?.toDate(fmt: "yyyy-MM-dd")
        if let date = date {
            headerCell?.lb_Date.text = date.string(fmt: "MM.dd(\(date.getWeakDay()))")
        } else {
            headerCell?.lb_Date.text = ""
        }
        
        return headerCell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section].predictNextWeekList?[indexPath.row]
        let cell: WeekOrderCell = tableView.dequeueReusableCell(for: indexPath)
        cell.lb_Title.text = item?.productName
        cell.lb_Count.text = String(format: "%ld건", item?.counts ?? 0)
        return cell
    }

}

