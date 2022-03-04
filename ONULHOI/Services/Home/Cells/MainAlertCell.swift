//
//  MainAlertCell.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/03.
//

import UIKit

class MainAlertCell: UMTableViewCell {

    @IBOutlet weak var lb_Title: UILabel!
    @IBOutlet weak var btn_Close: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
