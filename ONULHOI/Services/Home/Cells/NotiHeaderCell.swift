//
//  NotiHeaderCell.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/03.
//

import UIKit

class NotiHeaderCell: UMTableViewCell {

    @IBOutlet weak var lb_Title: UILabel!
    @IBOutlet weak var lb_Date: UILabel!
    @IBOutlet weak var iv_Arrow: UIImageView!
    @IBOutlet weak var btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
