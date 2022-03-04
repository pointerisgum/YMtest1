//
//  ListHeaderCell.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/03.
//

import UIKit

class ListHeaderCell: UMTableViewCell, NibLoadable {

    @IBOutlet weak var lb_Title: UILabel!
    @IBOutlet weak var lb_Count: UILabel!
    @IBOutlet weak var lc_Top: NSLayoutConstraint!
    @IBOutlet weak var lc_Bottom: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
