//
//  AskViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/05.
//

import UIKit

extension AskViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Home", bundle: nil)
}

class AskViewController: UMBaseViewController {

    @IBOutlet weak var tbv_List: UITableView!
    var items: [NDSupport] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reload()
    }
    
    func reload() {
        let sender = MRest.Sender(path: .support, method: .get)
        MRest.shared.request(sender) { (resp: MRest.Resp<NARows<NDSupport>>) in
            guard resp.code == .success else {
                return
            }

            self.items = resp.object.rows
            self.tbv_List.reloadData()
        }
    }
}

extension AskViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell: AskCell = tableView.dequeueReusableCell(for: indexPath)
        cell.lb_Name.text = item.managerName
        cell.lb_Phone.text = item.managerPhoneNumber
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        guard let url = URL(string: "tel://\(item.managerPhoneNumber!.onlyDigits())"),
            UIApplication.shared.canOpenURL(url) else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
