//
//  UMStatusView.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 21..
//  Copyright © 2017년 pplus. All rights reserved.
//

import UIKit

// MARK: - UMStatusView

final class UMStatusView: UMView {
	
	class func statusView(inView: UIView, text: String) -> UMStatusView {
		let frame: CGRect = {
			switch inView {
			case let scrollView as UIScrollView:
				var frame = inView.bounds
				frame.size.height -= (scrollView.contentInset.top + scrollView.contentInset.bottom)
				return frame
			default:
				return inView.bounds
			}
		}()
		
		let statusView = UMStatusView(frame: frame)
		statusView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		statusView.backgroundColor = .clear
		statusView.textLabel.text = text
		
		return statusView
	}
	
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
