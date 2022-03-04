//
//  UMPageIndicator.swift
//  PageIndicatorDemo
//
//  Created by Mac on 2018. 1. 23..
//  Copyright © 2018년 Mac. All rights reserved.
//

import UIKit

extension UMPageIndicator {
	
	struct CST {
		static let dotColor = UIColor(hex: 0xd0d0d0)
		static let selectedDotColor = UIColor(hex: 0x579ffb)
		
		static let titleH: CGFloat = 40
		static let dotH: CGFloat = 10
		static let dotSize: CGFloat = 6
		static let selectedDotSize: CGFloat = 19
		
		static let font = UIFont.systemFont(ofSize: 15, weight: .regular)
		static let selectedFont = UIFont.systemFont(ofSize: 15, weight: .regular)
	}
	
}

extension UMPageIndicator {
	
	final class Item {
		var title: String
		
		init(title: String = "") {
			self.title = title
		}
	}
	
	final class DotButton: UIButton {
		var lcDotWidth: NSLayoutConstraint?
		var lcDotHeight: NSLayoutConstraint?
		lazy var indicator: UIImageView = {
			let view = UIImageView(frame: .zero)
			addSubview(view)
			view.translatesAutoresizingMaskIntoConstraints = false
			lcDotWidth = view.widthAnchor.constraint(equalToConstant: CST.dotSize)
			lcDotWidth?.isActive = true
			lcDotHeight = view.heightAnchor.constraint(equalToConstant: CST.dotSize)
			lcDotHeight?.isActive = true
			view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
			view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
			
			view.backgroundColor = CST.dotColor
			view.clipsToBounds = true
			view.layer.cornerRadius = CST.dotSize/2
			return view
		}()
	}
	
}

@IBDesignable final class UMPageIndicator: UMControl {
	
	@IBInspectable var dotColor: UIColor = CST.dotColor {
		didSet {
			configureAll()
		}
	}
	
	@IBInspectable var selectedDotColor: UIColor = CST.selectedDotColor {
		didSet {
			configureAll()
		}
	}
	
	@IBInspectable var dotSize: CGFloat = CST.dotSize {
		didSet {
			configureAll()
		}
	}
	
	@IBInspectable var selectedDotSize: CGFloat = CST.selectedDotSize {
		didSet {
			configureAll()
		}
	}
	
	@IBInspectable var index: Int = 0 {
		didSet {
			configureAll()
			
			if index != oldValue {
				sendActions(for: .valueChanged)
			}
		}
	}
	func setIndex(_ index: Int, animated: Bool = false) {
		if animated {
			UIView.animate(withDuration: 0.25, delay: 0, options: [.curveLinear], animations: {
				self.index = index
				self.layoutIfNeeded()
			}, completion: { finished in
				
			})

		} else {
			self.index = index
		}
	}
	
	@IBInspectable var count: Int = 0 {
		didSet {
			items = (0..<count).compactMap { _ in Item() }
		}
	}
	
	@IBInspectable var titlesText: String = "" {
		didSet {
			titles = titlesText.components(separatedBy: ",")
		}
	}
	
	var titles: [String] = [] {
		didSet {
			items = titles.compactMap { Item(title: $0) }
		}
	}
	
	var items: [Item] = [] {
		didSet {
			configureAll()
		}
	}
	
	var font: UIFont = CST.font {
		didSet {
			configureAll()
		}
	}
	
	var selectedFont: UIFont = CST.selectedFont {
		didSet {
			configureAll()
		}
	}
	
	override var intrinsicContentSize: CGSize {
		var size = super.intrinsicContentSize
		size.height = (CST.titleH + CST.dotH)
		
		return size
	}
	
	override func doLayout() {
		super.doLayout()
		
		containerView.addArrangedSubview(titleContainerView)
		containerView.addArrangedSubview(dotContainerView)
		
		var lcHeight = titleContainerView.heightAnchor.constraint(equalToConstant: CST.titleH)
		lcHeight.priority = UILayoutPriority(rawValue: 999)
		lcHeight.isActive = true
		
		lcHeight = dotContainerView.heightAnchor.constraint(equalToConstant: CST.dotH)
		lcHeight.priority = UILayoutPriority(rawValue: 999)
		lcHeight.isActive = true
		
		configureAll()
	}
	
	func configureDots() {
		if dotContainerView.arrangedSubviews.count != items.count {
			dotContainerView.arrangedSubviews.forEach {
				dotContainerView.removeArrangedSubview($0)
				$0.removeFromSuperview()
			}
			
			(0..<items.count).forEach {
				let button = DotButton(frame: bounds)
				button.tag = $0
				button.addTarget(self, action: #selector(onSelected(_:)), for: .touchUpInside)
				dotContainerView.addArrangedSubview(button)
			}
		}
		
		dotContainerView.arrangedSubviews.compactMap { $0 as? DotButton }.forEach {
			if $0.tag == index {
				$0.indicator.backgroundColor = selectedDotColor
				$0.lcDotWidth?.constant = selectedDotSize
				
			} else {
				$0.indicator.backgroundColor = dotColor
				$0.lcDotWidth?.constant = dotSize
			}
			
			$0.indicator.layer.cornerRadius = dotSize/2
			$0.lcDotHeight?.constant = dotSize
		}
	}
	
	func configureTitles() {
		if titleContainerView.arrangedSubviews.count != items.count {
			titleContainerView.arrangedSubviews.forEach {
				titleContainerView.removeArrangedSubview($0)
				$0.removeFromSuperview()
			}
			
			items.enumerated().forEach {
				let button = UIButton(frame: bounds)
				button.tag = $0
				button.setTitle($1.title, for: .normal)
				button.addTarget(self, action: #selector(onSelected(_:)), for: .touchUpInside)
				titleContainerView.addArrangedSubview(button)
			}
		}
		
		titleContainerView.arrangedSubviews.compactMap { $0 as? UIButton }.forEach {
			if $0.tag == index {
				$0.titleLabel?.font = selectedFont
				$0.setTitleColor(selectedDotColor, for: .normal)
			} else {
				$0.titleLabel?.font = font
				$0.setTitleColor(dotColor, for: .normal)
			}
		}
	}
	
	func configureAll() {
		configureDots()
		
		let isOnlyDots = (items.filter { $0.title.count > 0 }.count == 0)
		
		titleContainerView.isHidden = isOnlyDots
		if isOnlyDots {
			dotContainerView.arrangedSubviews.forEach {
				$0.widthAnchor.constraint(equalToConstant: selectedDotSize).isActive = true
			}
		} else {
			configureTitles()
		}
	}
	
	@IBAction func onSelected(_ sender: UIButton) {
		setIndex(sender.tag, animated: true)
	}
	
	lazy var containerView: UIStackView = {
		let view = UIStackView(frame: bounds)
		addSubview(view)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		view.topAnchor.constraint(equalTo: topAnchor).isActive = true
		view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		
		view.axis = .vertical
		//view.distribution = .fillEqually
		return view
	}()
	
	lazy var titleContainerView: UIStackView = {
		let view = UIStackView(frame: bounds)
		view.axis = .horizontal
		view.distribution = .fillEqually
		view.isLayoutMarginsRelativeArrangement = true
		view.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
		return view
	}()
	
	lazy var dotContainerView: UIStackView = {
		let view = UIStackView(frame: bounds)
		view.axis = .horizontal
		view.distribution = .fillEqually
		view.isLayoutMarginsRelativeArrangement = true
		view.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
		return view
	}()

}
