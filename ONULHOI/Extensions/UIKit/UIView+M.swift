//
//  UIView+M.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 22..
//  Copyright © 2017년 pplus. All rights reserved.
//

import UIKit

enum Direction {
    case vertical
    case horizontal
    case center
}

extension UIView {
	
	var isShowing: Bool {
		get { return !isHidden }
		set { isHidden = !newValue }
	}
	
	func applyCicleLayer() {
		clipsToBounds = true
		
		layer.cornerRadius = floor(min(frame.width/2, frame.height/2))
	}
    
    func applyRoundedRectLayer(border: CGFloat = 6) {
        clipsToBounds = true
        
        layer.cornerRadius = floor(min(frame.width/border, frame.height/border))
    }
	
	func setShodow(color: UIColor, opacity: Float = 1, offset: CGSize = CGSize(width: 0, height: 0.5), radius: CGFloat = 5) {
		clipsToBounds = false
		
		layer.shadowColor = color.cgColor
		layer.shadowOpacity = opacity
		layer.shadowOffset = offset
		layer.shadowRadius = radius
	}
	
    func addGradientLayer(direction: Direction = .vertical, startColor: UIColor!, endColor: UIColor!) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = .init(x: 0, y: 0)

        switch direction {
        case .vertical:
            gradientLayer.endPoint = .init(x: 0, y: 1)
        case .horizontal:
            gradientLayer.endPoint = .init(x: 1, y: 0)
        case .center:
            gradientLayer.endPoint = .init(x: 1, y: 1)
        }
        
        gradientLayer.frame = self.bounds
                
        layer.insertSublayer(gradientLayer, at:0)
    }
}

// MARK: - Animations

public extension CALayer {
	
	class func animate(_ animation: () -> Void, completion: (() -> Void)? = nil) {
		CATransaction.begin()
		if let completion = completion {
			CATransaction.setCompletionBlock { completion() }
		}
		animation()
		CATransaction.commit()
	}
	
}


extension UIView {
	
	func roundCorners() {
//		layer.cornerRadius = frame.size.height/2
        layer.cornerRadius = 4
		layer.masksToBounds = true
	}
	func flipLeft() {
		UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
	}
	func flipRight() {
		UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
	}
	func flipBottom() {
		UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromBottom, animations: nil, completion: nil)
	}
	func flipTop() {
		UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
	}
	func crossDissolve() {
		UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
	}
	func flipCurlUp() {
		UIView.transition(with: self, duration: 0.5, options: .transitionCurlUp, animations: nil, completion: nil)
	}
	func flipCurlDown() {
		UIView.transition(with: self, duration: 0.5, options: .transitionCurlDown, animations: nil, completion: nil)
	}
	
	func scaleBouncing(withDuration duration: TimeInterval, animations: @escaping () -> Swift.Void, completion: (() -> Void)? = nil) {
		CALayer.animate({
			animations()
			
			let animation = CAKeyframeAnimation(keyPath: "transform.scale")
			animation.values = [0, 0.2 * 1, -0.2 * 1, 0.2 * 1, 0]
			animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
			animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
			animation.duration = duration
			animation.isAdditive = true
			animation.repeatCount = Float(1)
			animation.beginTime = CACurrentMediaTime() + 0.3
			self.layer.add(animation, forKey: "pop")
		}, completion: completion)
	}
	
    func addConstraintEqual(target: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: target.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: target.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: target.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: target.trailingAnchor, constant: 0).isActive = true
    }
    
    func addDashedBorder(color: UIColor, width: CGFloat) {
        //Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
        shapeLayer.lineDashPattern = [3,3]

        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: self.frame.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}

// MAKR: Debugging

extension UIView {
	
	func __debugDrawLine(_ depth: Int) {
		struct CST {
			static let colors: [UIColor] = [.gray, .blue, .yellow, .magenta, .orange, .purple, .brown, .gray, .cyan]
		}
		
		let color = depth < CST.colors.count ? CST.colors[depth] : UIColor(hex: Int(arc4random()%0xffffff))
		
		self.layer.borderWidth = 1
		self.layer.borderColor = color.cgColor
		self.subviews.forEach { $0.__debugDrawLine(depth + 1) }
	}
	
	func __debugRemoveALLLine() {
		self.layer.borderWidth = 0
		self.subviews.forEach { $0.__debugRemoveALLLine() }
	}	
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

extension UIView {
    func hideAnimated(in stackView: UIStackView) {
        if !self.isHidden {
            UIView.animate(
                withDuration: 0.15,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.isHidden = true
                    stackView.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
    
    func showAnimated(in stackView: UIStackView) {
        if self.isHidden {
            UIView.animate(
                withDuration: 0.15,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.isHidden = false
                    stackView.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
    

}
