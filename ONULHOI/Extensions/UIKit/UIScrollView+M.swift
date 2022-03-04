//
//  UIScrollView+M.swift
//  Lulla
//
//  Created by Mac on 2018. 5. 11..
//  Copyright © 2018년 pplus. All rights reserved.
//

import UIKit

extension UIScrollView {
	
	func setTopBackgroundColor(_ color: UIColor) {
		let view: UIView = {
			if let view = viewWithTag(92389283) {
				return view
			}
			
			let view = UIView(frame: CGRect(x: 0, y: -frame.height, width: frame.width, height: frame.height))
			view.autoresizingMask = [.flexibleWidth]
			view.tag = 92389283
			addSubview(view)
//			view.translatesAutoresizingMaskIntoConstraints = false
//			view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//			view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//			view.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
//			view.bottomAnchor.constraint(equalTo: topAnchor).isActive = true
			
			return view
		}()
		
		view.superview?.sendSubviewToBack(view)
		view.backgroundColor = color
	}
	
    func scrollToBottom(animated: Bool) {
      if self.contentSize.height < self.bounds.size.height { return }
      let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
      self.setContentOffset(bottomOffset, animated: animated)
   }
}
