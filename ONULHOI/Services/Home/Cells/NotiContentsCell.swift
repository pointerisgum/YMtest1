//
//  NotiContentsCell.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/04.
//

import UIKit

class NotiContentsCell: UMTableViewCell {

    @IBOutlet weak var lb_Contents: UILabel!
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
