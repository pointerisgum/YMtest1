//
//  IssuDetailDelayContentsCell.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/09.
//

import UIKit

class IssuDetailDelayContentsCell: UMTableViewCell {

    @IBOutlet weak var lb_Title: UILabel!
    @IBOutlet weak var lb_Contents: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
