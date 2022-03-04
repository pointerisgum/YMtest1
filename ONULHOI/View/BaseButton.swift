//
//  BaseButton.swift
//  Lulla
//
//  Created by 김영민 on 2021/04/14.
//

import UIKit

enum ButtonStyle {
    case enable
    case disable
}

class BaseButton: UIButton {
    
//    @IBInspectable var customStyle: ButtonStyle = .enable {
//        didSet {
//            buttonStyle(style: customStyle)
//        }
//    }

    func buttonStyle(style: ButtonStyle) {
        switch style {
        case .enable:
            setTitleColor(UIColor.white, for: .normal)
            backgroundColor = UIColor.hexColor(0x73cdc0)
        case .disable:
            setTitleColor(UIColor.hexColor(0xcccccc), for: .normal)
            backgroundColor = UIColor.hexColor(0xf2f2f2)
        }
    }

    
}
