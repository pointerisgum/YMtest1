//
//  PPAlertView.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 8..
//  Copyright © 2017년 pplus. All rights reserved.
//

import UIKit

/// PPAlert
final class PPAlert {

    class func present(inVC vc: UIViewController? = UIApplication.topViewController(), title: String = HSTR("알림"), message: String? = nil, actions: [UMAction] = [UMAction(title: HSTR("comm.confirm"))]) {
        let alertVC = AlertViewController.instantiate()
        alertVC.text = title
        alertVC.message = message
        alertVC.actions = actions
        vc?.present(alertVC, animated: true)
        alertVC.show()
    }
}
