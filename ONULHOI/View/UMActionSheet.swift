//
//  UMActionSheet.swift
//  Lulla
//
//  Created by Mac on 2018. 2. 23..
//  Copyright © 2018년 pplus. All rights reserved.
//

import UIKit

extension UMActionSheet {
	
	enum Style {
		case `default`
	}
	
	class Action {
		var title: String
		var style: Style
		var handler: ((Action) -> Void)?
		
		init(title: String, style: Style = .default, handler: ((Action) -> Void)? = nil) {
			self.title = title
			self.style = style
			self.handler = handler
		}
		
		class func action(title: String, style: Style = .default, handler: ((Action) -> Void)? = nil) -> Action {
			return Action(title: title, style: style, handler: handler)
		}
		
	}
	
}


final class UMActionSheet {
	
	class func present(inVC vc: UIViewController?, title: String? = nil, message: String? = nil, texts: [String], selectedIndex: Int? = nil, handler: @escaping (_ selectedIndex: Int?) -> Void) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
		
		texts.enumerated().forEach { (offset, element) in
			alert.addAction(UIAlertAction(title: element, style: .default) { action in
				handler(offset)
			})
		}
		
		alert.addAction(UIAlertAction(title: HSTR("comm.cancel"), style: .cancel) { action in
			handler(nil)
		})
		
		vc?.present(alert, animated: true, completion: nil)
	}
	
}
