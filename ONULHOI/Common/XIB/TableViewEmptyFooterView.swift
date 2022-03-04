//
//  TableViewEmptyFooterView.swift
//  Lulla
//
//  Created by 김영민 on 2021/01/06.
//

import UIKit

class TableViewEmptyFooterView: UITableViewHeaderFooterView, Reusable, NibLoadable {
    
    @IBOutlet weak var iv_Icon: UIImageView!
    @IBOutlet weak var lb_Title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
