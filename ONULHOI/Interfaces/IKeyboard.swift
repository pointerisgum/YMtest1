//
//  IKeyboard.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 1..
//  Copyright © 2017년 Mac. All rights reserved.
//

import UIKit

protocol IKeyboard {
    func registerKeyboardNotifications(observers: inout [NSObjectProtocol], scrollView: UIScrollView, padding: CGFloat?, moveUp: Bool)
}

extension IKeyboard where Self: UIViewController {
    func registerKeyboardNotifications(observers: inout [NSObjectProtocol], scrollView: UIScrollView, padding: CGFloat? = 0, moveUp: Bool = false) {
        observers.append(
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { noti in
                guard let userInfo = noti.userInfo else { return }
                
                let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
                let options = UIView.AnimationOptions(rawValue: UInt(truncating: userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber))
                let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                let insets = UIEdgeInsets(top: 0, left: 0, bottom: endFrame.size.height - self.view.safeAreaInsets.bottom - (padding ?? 0), right: 0)

                UIView.animate(withDuration: duration, delay: 0, options: [options], animations: {
                    scrollView.contentInset = insets
                    scrollView.scrollIndicatorInsets = insets
                    if moveUp {
                        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y + insets.bottom)
                    }
                }, completion: { (finished) in
                    
                })
            }
        )
        
        observers.append(
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (noti) in
                guard let userInfo = noti.userInfo else { return }

                let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
                let options = UIView.AnimationOptions(rawValue: UInt(truncating: userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber))

                UIView.animate(withDuration: duration, delay: 0, options: [options], animations: {
                    scrollView.contentInset = .zero
                    scrollView.scrollIndicatorInsets = .zero
//                    scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
//                    scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
                }, completion: { (finished) in

                })
            }
        )
    }
    
}
