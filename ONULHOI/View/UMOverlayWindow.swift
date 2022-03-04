//
//  UMOverlayWindow.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 8..
//  Copyright © 2017년 pplus. All rights reserved.
//

import UIKit

// MARK: - UMOverlayWindow

extension UMOverlayWindow {
	
	struct Options: OptionSet {
		let rawValue: Int
		
		static let topMost = Options(rawValue: 1)
		static let transparent = Options(rawValue: 2)
	}
	
}

final class UMOverlayWindow: UMWindow {
	
	static let sharedTransparent: UMOverlayWindow = {
		let window = UMOverlayWindow(frame: UIScreen.main.bounds)
		window.options = [.topMost, .transparent]
		return window
	}()
	
	static let shared: UMOverlayWindow = {
		let window = UMOverlayWindow(frame: UIScreen.main.bounds)
		window.options = [.topMost]
		return window
	}()
	
	var options: Options = [] {
		didSet {
			windowLevel = options.contains(.topMost) ? UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude) : UIWindow.Level.normal
			
			if options.contains(.transparent) {
				isUserInteractionEnabled = false
				backgroundColor = .clear
			} else {
				isUserInteractionEnabled = true
				backgroundColor = UIColor(hex: 0x000000, alpha: 0.4)
			}
		}
	}
	
	override func doLayout() {
		super.doLayout()
		
		options = [.topMost, .transparent]
		
		isHidden = true
	}
	
	override func didAddSubview(_ subview: UIView) {
		super.didAddSubview(subview)
		
		isHidden = false
	}
	
	override func willRemoveSubview(_ subview: UIView) {
		if subviews.count <= 1 {
			isHidden = true
		}
		
		super.willRemoveSubview(subview)
	}
	
}
