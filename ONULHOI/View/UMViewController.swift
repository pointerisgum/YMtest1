//
//  UMViewController.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 1..
//  Copyright © 2017년 Mac. All rights reserved.
//

import UIKit

// MARK: - UMBaseViewController

class UMBaseViewController: UIViewController {
	
	lazy var observers: [NSObjectProtocol] = []
	
	deinit {
		clearObservers()
		
		print("---->[deinit]\(self)")
	}
	
	func clearObservers() {
		observers.forEach({ NotificationCenter.default.removeObserver($0) })
		
		observers.removeAll()
	}
	
}

// MARK: - UMViewController

@IBDesignable class UMViewController: UMBaseViewController {
	
    private(set) var onceFlag = (willAppear: false, didAppear: false)
    
//    @IBOutlet weak var stv_Main: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if onceFlag.willAppear == false {
            onceFlag.willAppear = true
            
            doOnceViewWillAppear()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if onceFlag.didAppear == false {
            onceFlag.didAppear = true
            
            doOnceViewDidAppear()
        }
    }

	func doOnceViewWillAppear() {

    }
	
	func doOnceViewDidAppear() {
		
	}
}

