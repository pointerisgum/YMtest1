//
//  UMCollectionReusableView.swift
//  Lulla
//
//  Created by Mac on 2018. 1. 26..
//  Copyright © 2018년 pplus. All rights reserved.
//

import UIKit

// MARK: - UMCollectionReusableView

class UMCollectionReusableView: UICollectionReusableView, Reusable {
	
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

// MARK: - UMCollectionEmptyView

final class UMCollectionEmptyView: UMCollectionReusableView {
	
	lazy var textLabel: UILabel = {
		let label = UILabel(frame: bounds.insetBy(dx: 22, dy: 0))
		label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		label.backgroundColor = .clear
		label.textColor = UIColor(hex: 0x737373)
		label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		label.numberOfLines = 0
		label.textAlignment = .center
		addSubview(label)
		
		return label
	}()
	
}
