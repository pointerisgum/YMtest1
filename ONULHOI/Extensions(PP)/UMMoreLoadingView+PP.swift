//
//  UMMoreLoadingView+PP.swift
//  Lulla
//
//  Created by Mac on 2018. 3. 29..
//  Copyright © 2018년 pplus. All rights reserved.
//

import UIKit

extension UMMoreLoadingView {
	
	func embed(in scrollView: UIScrollView, delegate: UMMoreLoadingViewDelegate) {
		scrollView.contentInset.bottom += UMMoreLoadingViewBottomMargin
		self.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: UMMoreLoadingViewHeight)
		self.delegate = delegate
		scrollView.addSubview(self)
	}
	
	func setVisible<T>(with api: NARows<T>) where T: JSONDecodable {
		isVisible = (api.rows.count >= MRest.defaultSz)
	}
	
	func setVisible<T>(with api: NAGet<T>) where T: JSONDecodable {
		if let rowCount = api.row?.content?.count {
			isVisible = (rowCount >= MRest.defaultSz)
		} else {
			isVisible = false
		}
	}
	
}
