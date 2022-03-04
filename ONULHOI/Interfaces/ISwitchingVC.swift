//
//  ISwitchingVC.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 1..
//  Copyright © 2017년 Mac. All rights reserved.
//

import UIKit

enum SwitchingVCType {
	case intro
//	case tutorial
//	case join
	case login
	case main
}

protocol ISwitchingVC {
	typealias Completion = (_ vc: UIViewController) -> Void
	
	func switching(to type: SwitchingVCType, completion: Completion?)
}

extension ISwitchingVC {
	
	func switching(to type: SwitchingVCType, completion: Completion? = nil) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate, let window = sceneDelegate.window else {
			return
		}
		
		let vc = { () -> UIViewController in
			switch type {
			case .intro:
				return IntroViewController.instantiate()
//			case .tutorial:
////                return TutorialViewController.instantiate().vc
////                return UINavigationController(rootViewController: TutorialViewController.instantiate().vc)
//                return UMNavigationController(rootViewController: TutorialViewController.instantiate())
//            case .join:
//                return JoinViewController.instantiate()
////			case .join:
////				let vc = AuthCertPhoneJoinViewController.instantiate()
////				vc.joinMode = .app
////				return UMNavigationController(rootViewController: vc)
			case .login:
                return UMNavigationController(rootViewController: LoginViewController.instantiate())
            case .main:
				return MainTabBarController.instantiate()
			}
		}()
		
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
			let enabled = UIView.areAnimationsEnabled
			UIView.setAnimationsEnabled(false)
			window.rootViewController = vc
			UIView.setAnimationsEnabled(enabled)
		}) { (finished) in
			completion?(vc)
		}
	}
	
}

