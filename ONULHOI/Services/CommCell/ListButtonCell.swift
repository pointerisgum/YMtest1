//
//  ListButtonCell.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/03.
//

import UIKit

class ListButtonCell: UMTableViewCell, NibLoadable {

    @IBOutlet weak var btn: UIBButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
