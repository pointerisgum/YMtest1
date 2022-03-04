//
//  UIViewController+M.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 27..
//  Copyright © 2017년 pplus. All rights reserved.
//

import UIKit

enum Edge : Float {
    case top
    case bottom
}

extension UIViewController {
	
	func isModal() -> Bool {
		return (presentingViewController != nil)
			|| (navigationController?.presentingViewController?.presentedViewController == navigationController)
			|| (self.tabBarController?.presentingViewController is UITabBarController)
	}
	
}

extension UIViewController {
    
    func addTopSafeAreaView(color: UIColor = .mainColor, edge: Edge) {
        let statusBg = UIView()
        statusBg.translatesAutoresizingMaskIntoConstraints = false
        statusBg.backgroundColor = color
        view.addSubview(statusBg)

        switch edge {
        case .top:
            statusBg.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            statusBg.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            statusBg.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            statusBg.heightAnchor.constraint(equalToConstant: UIWindow.keyWindow?.safeAreaInsets.top ?? 0).isActive = true
        case .bottom:
            statusBg.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            statusBg.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            statusBg.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            statusBg.heightAnchor.constraint(equalToConstant: UIWindow.keyWindow?.safeAreaInsets.bottom ?? 0).isActive = true
        }
    }
    
    func m_addChild(_ child: UIViewController?, to containerView: UIView? = nil, contentInset: UIEdgeInsets? = nil) {
        guard let child = child else { return }
        guard let containerView = containerView ?? view else { return }
        
        addChild(child)
        
        child.view.translatesAutoresizingMaskIntoConstraints = false
        child.view.frame = containerView.bounds
        containerView.addSubview(child.view)
        let lcLeft = child.view.leftAnchor.constraint(equalTo: containerView.leftAnchor)
        let lcRight = child.view.rightAnchor.constraint(equalTo: containerView.rightAnchor)
        let lcTop = child.view.topAnchor.constraint(equalTo: containerView.topAnchor)
        let lcBottom = child.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        
        if let contentInset = contentInset {
            child.view.frame = child.view.frame.inset(by: contentInset)
            lcLeft.constant = contentInset.left
            lcRight.constant = contentInset.right
            lcTop.constant = contentInset.top
            lcBottom.constant = contentInset.bottom
        }
        
        NSLayoutConstraint.activate([lcLeft, lcRight, lcTop, lcBottom])
        
        child.didMove(toParent: self)
    }
    
    func m_removeFromParent() {
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func goDismiss(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
