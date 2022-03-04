//
//  UIApplication+M.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 12..
//  Copyright © 2017년 pplus. All rights reserved.
//

import UIKit

extension UIApplication {
	
    class func topViewController(base: UIViewController? = UIWindow.keyWindow?.rootViewController) -> UIViewController? {
		if let nav = base as? UINavigationController {
			return topViewController(base: nav.visibleViewController)
		}
		if let tab = base as? UITabBarController {
			if let selected = tab.selectedViewController {
				return topViewController(base: selected)
			}
		}
		if let presented = base?.presentedViewController {
			return topViewController(base: presented)
		}
		return base
	}
	
	class var safeAreaInsets: UIEdgeInsets? {
		if #available(iOS 11, *) {
            return UIWindow.keyWindow?.safeAreaInsets
		} else {
			return nil
		}
	}
	
}

extension UIApplication {
	
	@discardableResult func open(urlString: String?) -> Bool {
		if let urlString = urlString, let url = URL(string: urlString) {
			if canOpenURL(url) {
				return openURL(url)
			}
		}
		
		return false
	}
	
	@discardableResult func open(urlStrings: [String]) -> Bool {
		for urlString in urlStrings {
			if open(urlString: urlString) == true {
				return true
			}
		}
		
		return false
	}
	
}

