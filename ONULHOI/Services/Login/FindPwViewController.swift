//
//  FindPwViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2021/12/30.
//

import UIKit
import TweeTextField

extension FindPwViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Login", bundle: nil)
}

class FindPwViewController: UMInputBarViewController {

    @IBOutlet weak var tf_Business: TweeAttributedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputBar.btn.text = HSTR("login.getTempPw")
        inputBar.delegate = self
        tf_Business.becomeFirstResponder()
    }
}

extension FindPwViewController: UMInputBarDelegate {
    func didSelected() {
                
        guard tf_Business.text?.count ?? 0 > 0 else {
            return
        }

        tf_Business.resignFirstResponder()
        
        var sender = MRest.Sender(path: .findPassword, method: .put)
        sender.parameters[Keys.id] = tf_Business.text
        MRest.shared.request(sender) { (resp: MRest.Resp<NABase>) in
            guard resp.code == .success else {
                PPAlert.present(inVC: self, title: resp.message)
                return
            }

            self.navigationController?.popViewController(animated: true, completion: {
                UIWindow.keyWindow?.makeToast(message: "임시비밀번호를 발송해드렸습니다.")
            })
            

//            var actions: [UMAction] = []
//            actions.append(UMAction(title: HSTR("comm.confirm"), handler: {
//                self.navigationController?.popViewController(animated: true)
//            }))
//            PPAlert.present(inVC: self, title: HSTR("임시비밀번호를 발송해드렸습니다."), actions: actions)
        }        
    }
}
