//
//  UMLoadingView.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 8..
//  Copyright © 2017년 pplus. All rights reserved.
//

import UIKit

// MARK: - UMLoadingView

extension UMLoadingView {
	
	struct CST {
		static let tag = 902832
		static let animationDuration: TimeInterval = 1.5
	}
	
}

final class UMLoadingView: UMView {
	
	enum IndicatorStyle {
		case normal, white
	}
	
	fileprivate lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
		view.sizeToFit()
		view.center = CGPoint(x: frame.width/2, y: frame.height/2)
		view.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
		addSubview(view)

		return view
	}()
	
	override func doLayout() {
		super.doLayout()
		
		isUserInteractionEnabled = false
	}
	
	func show(inView: UIView) {
		removeFromSuperview()

        frame = inView.bounds
		autoresizingMask = [.flexibleWidth, .flexibleHeight]
		inView.addSubview(self)
	}
	
	func dismiss() {
		indicatorView.stopAnimating()
		
		UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
			self.alpha = 0
		}, completion: { finished in
			self.removeFromSuperview()
		})
	}
	
}

extension UIView {
	
	@discardableResult class func m_startLoading(inView: UIView = UMOverlayWindow.shared, indicatorStyle: UMLoadingView.IndicatorStyle = .white) -> UMLoadingView {
		let loadingView = { () -> UMLoadingView in
			guard let view = inView.viewWithTag(UMLoadingView.CST.tag) as? UMLoadingView else {
				let view = UMLoadingView(frame: inView.bounds)
				view.tag = UMLoadingView.CST.tag
				view.indicatorView.color = (indicatorStyle == .white) ? .white : .gray
				view.show(inView: inView)
				return view
			}
			return view
		}()
		loadingView.indicatorView.startAnimating()
		
		return loadingView
	}
	
	class func m_stopLoading(inView: UIView = UMOverlayWindow.shared) {
		if let loadingView = inView.viewWithTag(UMLoadingView.CST.tag) as? UMLoadingView {
			loadingView.dismiss()
		}
	}
	
}

protocol ILoadingView {
	@discardableResult func m_startLoading() -> UMLoadingView
	func m_stopLoading()
}

extension UIView: ILoadingView {}

extension ILoadingView where Self: UIView {
	
	@discardableResult func m_startLoading() -> UMLoadingView {
		return UMLoadingView.m_startLoading(inView: self, indicatorStyle: .normal)
	}
	
	func m_stopLoading() {
		UMLoadingView.m_stopLoading(inView: self)
	}
	
}

extension ILoadingView where Self: UIButton {
	
	@discardableResult func m_startLoading() -> UMLoadingView {
		isUserInteractionEnabled = false
		titleLabel?.alpha = 0
		imageView?.alpha = 0
		
		return UMLoadingView.m_startLoading(inView: self, indicatorStyle: .normal)
	}
	
	func m_stopLoading() {
		UMLoadingView.m_stopLoading(inView: self)
		
		isUserInteractionEnabled = true
		titleLabel?.alpha = 1
		imageView?.alpha = 1
	}
	
}
