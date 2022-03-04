//
//  ListReleaseCell.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/17.
//

import UIKit

class ListReleaseCell: UMTableViewCell, NibLoadable {

    @IBOutlet weak var lb_Title: UILabel!
    @IBOutlet weak var v_CountBg: UIBView!
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
