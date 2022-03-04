//
//  UMInputBarViewController.swift
//  PPBiz
//
//  Created by Mac on 2018. 7. 3..
//  Copyright © 2018년 Mac. All rights reserved.
//

import UIKit

// MARK: - UMInputBarViewController

class UMInputBarViewController: UMViewController {
    lazy var inputBar: UMInputBar = {
        let inputBar = UMInputBar.loadFromNib()
        inputBar.frame = CGRect(x: 0, y: 0, width: UIWindow.keyWindow?.bounds.width ?? self.view.bounds.width, height: UMInputBar.CST.defaultH)
        return inputBar
    }()
    
    override var inputAccessoryView: UIView? {
        return self.inputBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputBar.translatesAutoresizingMaskIntoConstraints = false
        inputBar.heightAnchor.constraint(equalToConstant: UMInputBar.CST.defaultH).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        inputBar.layoutIfNeeded()
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
    }
}

