//
//  UIWindow+M.swift
//  Lulla
//
//  Created by 김영민 on 2020/11/25.
//

import Foundation
import Toast_Swift

extension UIWindow {
    static var keyWindow: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }

    func makeToast(message: String) {
        UIWindow.keyWindow?.rootViewController?.view.makeToast(message)
    }
}
