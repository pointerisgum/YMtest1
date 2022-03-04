//
//  ListTimeHeaderCell.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/12.
//

import UIKit

class ListTimeHeaderCell: UMTableViewCell, NibLoadable {

    @IBOutlet weak var lb_Title: UILabel!
    @IBOutlet weak var lb_Count: UILabel!
    @IBOutlet weak var lc_Top: NSLayoutConstraint!
    @IBOutlet weak var lc_Bottom: NSLayoutConstraint!
    @IBOutlet weak var v_Line: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
