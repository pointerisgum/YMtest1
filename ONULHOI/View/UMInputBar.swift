//
//  UMInputBar.swift
//  PostPublishM
//
//  Created by p-plus on 2017. 2. 14..
//  Copyright © 2017년 p-plus. All rights reserved.
//

import UIKit

// MARK: - UMInputBar

protocol UMInputBarDelegate: AnyObject {
    func didSelected()
}

extension UMInputBar {
	struct CST {
//		static let defaultH: CGFloat = 52 + (UIWindow.keyWindow?.safeAreaInsets.bottom ?? 0) + 10
        static let defaultH: CGFloat = 52 + 20

	}
}

final class UMInputBar: UMView, NibLoadable {
	
    @IBOutlet weak var btn: UIBButton!
    
    weak var delegate: UMInputBarDelegate?

	override func doLayout() {
		super.doLayout()
	}
    
    @IBAction func goSelected(_ sender: Any) {
        delegate?.didSelected()
    }
}

