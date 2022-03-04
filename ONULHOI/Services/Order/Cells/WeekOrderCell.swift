//
//  WeekOrderCell.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/13.
//

import UIKit

class WeekOrderCell: UMTableViewCell {

    @IBOutlet weak var lb_Title: UILabel!
    @IBOutlet weak var lb_Count: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
