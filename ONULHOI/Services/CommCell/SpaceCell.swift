//
//  SpaceCell.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/12.
//

import UIKit

class SpaceCell: UMTableViewCell, NibLoadable {

    @IBOutlet weak var lc_Space: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
