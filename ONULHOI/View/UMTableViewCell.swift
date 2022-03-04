//
//  UMTableViewCell.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 15..
//  Copyright © 2017년 pplus. All rights reserved.
//

import UIKit

// MARK: - UMTableViewCell

class UMTableViewCell: UITableViewCell, Reusable {

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		doLayout()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		doLayout()
	}
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		doLayout()
	}
	
	func doLayout() {
		self.layoutMargins = UIEdgeInsets.zero
	}
}
