//
//  AskCell.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/05.
//

import UIKit

class AskCell: UMTableViewCell {

    @IBOutlet weak var lb_Name: UILabel!
    @IBOutlet weak var lb_Phone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
