//
//  BottomPopUpViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/09.
//

import UIKit

extension BottomPopUpViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Main", bundle: nil)
}

extension BottomPopUpViewController {
    class Item {
        var type: SortType!
        init(type: SortType) {
            self.type = type
        }
    }
}

class BottomPopUpViewController: UMViewController {

    @IBOutlet weak var v_Bg: UIView! {
        didSet {
            v_Bg.clipsToBounds = true
            v_Bg.layer.cornerRadius = 16
            v_Bg.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        }
    }
    @IBOutlet weak var lb_Title: UILabel!
    @IBOutlet weak var tbv_List: UITableView!
    @IBOutlet weak var lc_ContentsHeight: NSLayoutConstraint!
    
    var items: [Item] = []
    var completeHandler: ((SortType) -> Void)?
    var selectType: SortType!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var height = tbv_List.contentSize.height
        if height > view.bounds.height * 0.8 {
            height = view.bounds.height * 0.8
        }
        lc_ContentsHeight.constant = height
    }
}

extension BottomPopUpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BottomPopUpCell = tableView.dequeueReusableCell(for: indexPath)
        let item = items[indexPath.row]
        cell.btn.text = item.type.rawValue
        
        cell.btn.isSelected = selectType == item.type
        cell.btn.onTap {
            self.selectType = item.type
            self.tbv_List.reloadData()
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                if let completeHandler = self.completeHandler {
                    completeHandler(self.selectType)
                }
                self.dismiss(animated: true)
            }
        }
        return cell
    }
}
