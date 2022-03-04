//
//  ChangePwViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2021/12/30.
//

import UIKit
import TweeTextField

extension ChangePwViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Login", bundle: nil)
}

extension ChangePwViewController {
    enum Mode {
        case temp
        case change
    }
}

class ChangePwViewController: UMInputBarViewController, IKeyboard, IValidate {

    @IBOutlet weak var sv_Main: UIScrollView!
    @IBOutlet weak var v_TfBg: UIView! {
        didSet {
            v_TfBg.clipsToBounds = true
            v_TfBg.layer.borderWidth = 1
            v_TfBg.layer.cornerRadius = 8
//            v_TfBg.layer.borderColor = UIColor.color_ff1919.cgColor
            v_TfBg.layer.borderColor = UIColor.clear.cgColor
        }
    }
    @IBOutlet weak var v_TempPwBg: UIView! {
        didSet {
            v_TempPwBg.clipsToBounds = true
            v_TempPwBg.layer.borderWidth = 1
            v_TempPwBg.layer.borderColor = UIColor.color_ebebeb.cgColor
            v_TempPwBg.layer.cornerRadius = 8
            v_TempPwBg.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        }
    }
    @IBOutlet weak var v_PwBg: UIView! {
        didSet {
            v_PwBg.clipsToBounds = true
            v_PwBg.layer.borderWidth = 1
            v_PwBg.layer.borderColor = UIColor.color_ebebeb.cgColor
//            v_PwBg.layer.cornerRadius = 8
//            v_PwBg.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        }
    }
    
    @IBOutlet weak var v_PwConfirmBg: UIView! {
        didSet {
            v_PwConfirmBg.clipsToBounds = true
            v_PwConfirmBg.layer.borderWidth = 1
            v_PwConfirmBg.layer.borderColor = UIColor.color_ebebeb.cgColor
            v_PwConfirmBg.layer.cornerRadius = 8
            v_PwConfirmBg.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        }
    }
    @IBOutlet weak var tf_TempPw: TweeAttributedTextField!
    @IBOutlet weak var tf_Pw: TweeAttributedTextField!
    @IBOutlet weak var tf_PwConfirm: TweeAttributedTextField!
    @IBOutlet weak var lb_ErrMsg: UILabel!
    
    var mode: Mode = .change
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        registerKeyboardNotifications(observers: &observers, scrollView: sv_Main)

        switch mode {
        case .temp: tf_TempPw.tweePlaceholder = HSTR("임시비밀번호")
        case .change: tf_TempPw.tweePlaceholder = HSTR("현재 비밀번호")
        }
        
        inputBar.btn.text = HSTR("login.changeSuccess")
        inputBar.delegate = self
    }
    
    func showErrorUI(msg: String?) {
        self.view.endEditing(true)
        v_TfBg.layer.borderColor = UIColor.clear.cgColor
        v_TfBg.layer.borderColor = UIColor.color_ff1919.cgColor
        lb_ErrMsg.text = msg
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.v_TfBg.layer.borderColor = UIColor.clear.cgColor
//            self.lb_ErrMsg.text = ""
//        }
        
        
        
//        let queue = DispatchQueue(label: "queue", attributes: .concurrent)
//        let workItem = DispatchWorkItem {
//            self.v_TfBg.layer.borderColor = UIColor.clear.cgColor
//            self.lb_ErrMsg.text = ""
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//            queue.async(execute: workItem) // not work
//        }
//        workItem.cancel()

    }

}

extension ChangePwViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        v_TfBg.layer.borderColor = UIColor.clear.cgColor
        lb_ErrMsg.text = ""
        
        if textField == tf_TempPw {
            v_TempPwBg.layer.borderColor = UIColor.black.cgColor
            v_TfBg.bringSubviewToFront(v_TempPwBg)
        } else if textField == tf_Pw {
            v_PwBg.layer.borderColor = UIColor.black.cgColor
//            v_PwBg.layer.cornerRadius = 8
            v_TfBg.bringSubviewToFront(v_PwBg)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.tf_Pw.placeholder = HSTR("login.pwHint")
            }
        } else if textField == tf_PwConfirm {
            v_PwConfirmBg.layer.borderColor = UIColor.black.cgColor
            v_TfBg.bringSubviewToFront(v_PwConfirmBg)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tf_TempPw {
            v_TempPwBg.layer.borderColor = UIColor.color_ebebeb.cgColor
        } else if textField == tf_Pw {
            v_PwBg.layer.borderColor = UIColor.color_ebebeb.cgColor
            v_PwBg.layer.cornerRadius = 0
            tf_Pw.placeholder = ""
        } else if textField == tf_PwConfirm {
            v_PwConfirmBg.layer.borderColor = UIColor.color_ebebeb.cgColor
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tf_TempPw {
            tf_Pw.becomeFirstResponder()
        } else if textField == tf_Pw {
            tf_PwConfirm.becomeFirstResponder()
        } else if textField == tf_PwConfirm {
            didSelected()
        }
        return true
    }
}

extension ChangePwViewController: UMInputBarDelegate {
    func didSelected() {
        var validateResult = validate(.tempPassword, text: tf_TempPw.text, alert: false)
        if validateResult.isValid == false {
            self.showErrorUI(msg: validateResult.text)
            return
        }

        validateResult = validate(.password, text: tf_Pw.text, alert: false)
        if validateResult.isValid == false {
            self.showErrorUI(msg: validateResult.text)
            return
        }
        
        validateResult = validate(.confirmPassword, text: tf_PwConfirm.text, alert: false)
        if validateResult.isValid == false {
            self.showErrorUI(msg: validateResult.text)
            return
        }

        guard tf_Pw.text == tf_PwConfirm.text else {
            self.showErrorUI(msg: HSTR("validate.confirmPwd.notMatch"))
            return
        }

        //TODO: 비밀번호 변경 API 호출
        var sender = MRest.Sender(path: .changePassword, method: .put)
        sender.parameters[Keys.currentPlainPassword] = tf_TempPw.text
        sender.parameters[Keys.plainPassword] = tf_Pw.text
        MRest.shared.request(sender) { (resp: MRest.Resp<NABase>) in
            guard resp.code == .success else {
                self.showErrorUI(msg: resp.message)
                return
            }

            MData.shared.password = self.tf_Pw.text!
            
            self.navigationController?.popViewController(animated: true, completion: {
                UIWindow.keyWindow?.makeToast(message: "비밀번호 변경이 완료되었습니다.")
            })

//            var actions: [UMAction] = []
//            actions.append(UMAction(title: HSTR("comm.confirm"), handler: {
//                self.navigationController?.popViewController(animated: true)
//            }))
//            PPAlert.present(inVC: self, title: HSTR("비밀번호 변경이 완료되었습니다."), actions: actions)
        }
    }
}
