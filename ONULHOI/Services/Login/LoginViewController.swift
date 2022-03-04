//
//  LoginViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2021/12/29.
//

import UIKit
import TweeTextField

extension LoginViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Login", bundle: nil)
}

class LoginViewController: UMLoginViewController, IKeyboard {

    @IBOutlet weak var sv_Main: UIScrollView!
    @IBOutlet weak var stv_Tf: UIStackView! {
        didSet {
            stv_Tf.clipsToBounds = true
            stv_Tf.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var v_TfBg: UIView! {
        didSet {
            v_TfBg.clipsToBounds = true
            v_TfBg.layer.borderWidth = 1
            v_TfBg.layer.cornerRadius = 8
//            v_TfBg.layer.borderColor = UIColor.color_ff1919.cgColor
            v_TfBg.layer.borderColor = UIColor.clear.cgColor
        }
    }
    @IBOutlet weak var v_BusinessNoBg: UIView! {
        didSet {
            v_BusinessNoBg.clipsToBounds = true
            v_BusinessNoBg.layer.borderWidth = 1
            v_BusinessNoBg.layer.borderColor = UIColor.color_ebebeb.cgColor
            v_BusinessNoBg.layer.cornerRadius = 8
            v_BusinessNoBg.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        }
    }
    @IBOutlet weak var v_PwBg: UIView! {
        didSet {
            v_PwBg.clipsToBounds = true
            v_PwBg.layer.borderWidth = 1
            v_PwBg.layer.borderColor = UIColor.color_ebebeb.cgColor
            v_PwBg.layer.cornerRadius = 8
            v_PwBg.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        }
    }
    @IBOutlet weak var tf_BusinessNo: TweeAttributedTextField!
    @IBOutlet weak var tf_Pw: TweeAttributedTextField!
    @IBOutlet weak var lb_ErrMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         12340110001 123qwe //and1
         12340160002 123qwe //and2
         56780110001 123qwe //iOS1
         56780160002 123qwe //iOS2
         2848800848 123qwe
         */

#if DEBUG
        tf_BusinessNo.text = "2848800848"
        tf_Pw.text = "123qwe"
#endif
        
        registerKeyboardNotifications(observers: &observers, scrollView: sv_Main)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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

    @IBAction func goLogin(_ sender: Any) {
        var validateResult = validate(.loginId, text: tf_BusinessNo.text, alert: false)
        if validateResult.isValid == false {
            self.showErrorUI(msg: validateResult.text)
            return
        }

        validateResult = validate(.password, text: tf_Pw.text, alert: false)
        if validateResult.isValid == false {
            self.showErrorUI(msg: validateResult.text)
            return
        }

        login(id: tf_BusinessNo.text, pw: tf_Pw.text) { statusCode in
            switch statusCode {
            case .success:
                self.switching(to: .main)
            case .error(msg: let msg):
                print(msg)
                self.showErrorUI(msg: msg)
            }
        }
    }
    
    @IBAction func goFindPw(_ sender: Any) {
        
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        v_TfBg.layer.borderColor = UIColor.clear.cgColor
        lb_ErrMsg.text = ""

        if textField == tf_BusinessNo {
            v_BusinessNoBg.layer.borderColor = UIColor.black.cgColor
            v_TfBg.bringSubviewToFront(v_BusinessNoBg)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//                self.tf_BusinessNo.placeholder = "asdasdas"
//            }
            
        } else if textField == tf_Pw {
            v_PwBg.layer.borderColor = UIColor.black.cgColor
            v_TfBg.bringSubviewToFront(v_PwBg)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tf_BusinessNo {
            v_BusinessNoBg.layer.borderColor = UIColor.color_ebebeb.cgColor
//            tf_BusinessNo.placeholder = ""
        } else if textField == tf_Pw {
            v_PwBg.layer.borderColor = UIColor.color_ebebeb.cgColor
        }
    }
}
