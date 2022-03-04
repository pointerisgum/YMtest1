//
//  AlertViewController.swift
//  Lulla
//
//  Created by 김영민 on 2020/12/28.
//

import UIKit
enum UMActionStyle : Int {
    case confirm
    case cancel
}

enum UMActionType : Int {
    case `default`
    case error
//    case header
}

final class UMAction {
    var title: String
    var style: UMActionStyle
    var handler: (() -> Void)?
    
    init(title: String, style: UMActionStyle = .confirm, handler: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    
    class func action(title: String, style: UMActionStyle = .confirm, handler: (() -> Void)? = nil) -> UMAction {
        return UMAction(title: title, style: style, handler: handler)
    }
}

extension AlertViewController: StoryboardLoadable {
    static var ownerStoryboard: UIStoryboard = UIStoryboard(name: "Alert", bundle: nil)
}

class AlertViewController: UIViewController {

    @IBOutlet weak var lb_Title: UILabel!
    @IBOutlet weak var lb_Message: UILabel!
    @IBOutlet weak var btn_Cancel: UIBButton! {
        didSet {
            btn_Cancel.isHidden = true
        }
    }
    @IBOutlet weak var btn_Confirm: UIBButton! {
        didSet {
            btn_Confirm.isHidden = true
        }
    }
    @IBOutlet weak var v_MessageBg: UIView!
    
    var text: String?
    var message: String?
    var actions: [UMAction] = []
    var cancelHandler: (() -> Void)?
    var confirmHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func show() {
        lb_Title.text = text
        lb_Message.text = message
        v_MessageBg.isHidden = message?.count ?? 0 <= 0
        
        actions.forEach {
            switch $0.style {
            case .confirm:
                btn_Confirm.isHidden = false
                btn_Confirm.text = $0.title
                confirmHandler = $0.handler
            case .cancel:
                btn_Cancel.isHidden = false
                btn_Cancel.text = $0.title
                cancelHandler = $0.handler
            }
        }
    }
    
    @IBAction func goCancel(_ sender: Any) {
        self.dismiss(animated: true) {
            self.cancelHandler?()
        }
    }
    
    @IBAction func goConfirm(_ sender: Any) {
        self.dismiss(animated: true) {
            self.confirmHandler?()
        }
    }
}

