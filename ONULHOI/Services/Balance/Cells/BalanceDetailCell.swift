//
//  BalanceDetailCell.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/06.
//

import UIKit

class BalanceDetailCell: UMTableViewCell {

    @IBOutlet weak var lb_Title: UILabel!
    @IBOutlet weak var lb_Price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
