//
//  ListKeepContentsCell.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/12.
//

import UIKit

class ListKeepContentsCell: UMTableViewCell, NibLoadable {

    @IBOutlet weak var lb_Title: UILabel!
    @IBOutlet weak var iv_Icon: UIImageView!
    @IBOutlet weak var lb_Contents: UILabel!
    @IBOutlet weak var lb_Count: UILabel!
    @IBOutlet weak var btn_Action: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
