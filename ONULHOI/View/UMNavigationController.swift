//
//  UMNavigationController.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 1..
//  Copyright © 2017년 Mac. All rights reserved.
//

import UIKit

// MARK: - UINavigationBar Theme

extension UINavigationBar {
	
	struct CST {
		static let titleTextAttributes: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor(hex: 0x000000), .font: UIFont.systemFont(ofSize: 18, weight: .bold)]
	}
	
	func applyTheme() {
		isTranslucent = false
		shadowImage = UIImage(color: UIColor(hex: 0xd8d8d8), size: CGSize(width: 0.5, height: 0.5), scale: 1)
		setBackgroundImage(UIImage(color: UIColor(hex: 0xffffff)), for: .default)
		barTintColor = UIColor(hex: 0xffffff)
		tintColor = UIColor(hex: 0xffffff)
		titleTextAttributes = CST.titleTextAttributes
	}
	
}

// MARK: - UMNavigationController

final class UMNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
	
	var isEnabledPopGestureRecognizer = true
	
	// MARK: - Life Cycle
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	override init(rootViewController: UIViewController) {
		super.init(rootViewController: rootViewController)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return viewControllers.last?.preferredStatusBarStyle ?? .default
	}
	
	override var prefersStatusBarHidden: Bool {
		return viewControllers.last?.prefersStatusBarHidden ?? false
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		interactivePopGestureRecognizer?.delegate = self
		delegate = self
        isNavigationBarHidden = true
	}
	
	override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		if animated {
			interactivePopGestureRecognizer?.isEnabled = false
		}
		
		super.pushViewController(viewController, animated: animated)
	}
	
	override func popToRootViewController(animated: Bool) -> [UIViewController]? {
		if animated {
			interactivePopGestureRecognizer?.isEnabled = false
		}
		
		return super.popToRootViewController(animated: animated)
	}
	
	override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
		if animated {
			interactivePopGestureRecognizer?.isEnabled = false
		}
		
		return super.popToViewController(viewController, animated: animated)
	}
	
	func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		interactivePopGestureRecognizer?.isEnabled = true
	}
	
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		if gestureRecognizer == interactivePopGestureRecognizer,
			viewControllers.count < 2 || visibleViewController == viewControllers[0] {
			return false
		}
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SwipeBack"), object: nil, userInfo: nil)
		return isEnabledPopGestureRecognizer
	}
	
}

extension UINavigationController {
    func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }

    func popViewController(animated: Bool, completion: @escaping () -> Void) {
        popViewController(animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}
