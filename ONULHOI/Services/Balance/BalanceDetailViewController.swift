//
//  BalanceDetailViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/06.
//

import UIKit

extension BalanceDetailViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Balance", bundle: nil)
}

class BalanceDetailViewController: UMViewController {

    @IBOutlet weak var tbv_List: UITableView!
    @IBOutlet weak var lc_ContentsHeight: NSLayoutConstraint!
    @IBOutlet weak var lb_Date: UILabel!
    @IBOutlet weak var lb_TotalPrice: UILabel!

    var item: NDSettlement.DailySettlementResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        lb_Date.text = item.receiptDate
        let date = item.receiptDate?.toDate(fmt: "yyyy-MM-dd")
//        lb_Date.text = date?.string(fmt: "yyyy.MM.dd(\(date?.getWeakDay()))")
        if let date = date {
            lb_Date.text = date.string(fmt: "yyyy.MM.dd(\(date.getWeakDay()))")
        }
        lb_TotalPrice.text = (item.dailySettlementSum?.demicalString() ?? "0") + "원"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        lc_ContentsHeight.constant = tbv_List.contentSize.height
    }
}

extension BalanceDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.calculatedPrices?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BalanceDetailCell = tableView.dequeueReusableCell(for: indexPath)
        let subItem = item.calculatedPrices?[indexPath.row]
        cell.lb_Title.text = subItem?.name
        cell.lb_Price.text = (subItem?.totalPurchasingPrice?.demicalString() ?? "0") + "원"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
