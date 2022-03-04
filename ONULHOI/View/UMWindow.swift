//
//  UMWindow.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 8..
//  Copyright © 2017년 pplus. All rights reserved.
//

import UIKit

// MARK: - UMControl

class UMWindow: UIWindow {
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	required override init(frame: CGRect) {
		super.init(frame: frame)
		
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
		
	}
	
}
