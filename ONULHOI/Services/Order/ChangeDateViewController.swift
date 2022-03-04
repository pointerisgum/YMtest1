//
//  ChangeDateViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/19.
//

import UIKit
import KMPlaceholderTextView

extension ChangeDateViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Order", bundle: nil)
}

class ChangeDateViewController: UMInputBarViewController, IKeyboard {

    @IBOutlet weak var sv_Main: UIScrollView!
    @IBOutlet weak var tv_Contents: KMPlaceholderTextView!
    @IBOutlet weak var btn_Delay: UIButton!
    @IBOutlet weak var btn_Problem: UIButton!
    @IBOutlet weak var btn_Custom: UIButton!
    @IBOutlet weak var v_TvBg: UIView! {
        didSet {
            v_TvBg.alpha = 0.3
        }
    }

    var newDate: Date!
    var ids: [Int]?

    override func viewDidLoad() {
        super.viewDidLoad()

        registerKeyboardNotifications(observers: &observers, scrollView: sv_Main)

        inputBar.btn.text = newDate.string(fmt: "MM월 dd일") + " 변경하기"
        inputBar.delegate = self
    }
    
    func reqAPI() {
        var contents = ""
        if btn_Delay.isSelected {
            contents = btn_Delay.text!
        } else if btn_Problem.isSelected {
            contents = btn_Problem.text!
        } else if btn_Custom.isSelected {
            contents = tv_Contents.text
        }
        var sender = MRest.Sender(path: .changeDate)
        sender.parameters[Keys.operationInventoryIdList] = ids
        sender.parameters[Keys.requestDate] = newDate.string(fmt: "yyyy-MM-dd")
        sender.parameters[Keys.reason] = contents
        MRest.shared.request(sender) { (resp: MRest.Resp<NABase>) in
            guard resp.code == .success else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    PPAlert.present(inVC: self, title: resp.message)
                }
                return
            }
            print(resp.object)
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func goSelectedType(_ sender: UIButton) {
//        if sender != btn_Custom && tv_Contents.text.count > 0 {
//            var actions: [UMAction] = []
//            actions.append(UMAction(title: HSTR("comm.yes"), style: .confirm, handler: {
//                self.reqAPI()
//            }))
//            actions.append(UMAction(title: HSTR("comm.no"), style: .cancel, handler: {
//            }))
//            let title = "\(newDate.string(fmt: "MM월 dd일"))로 도착일 변경을\n요청하시겠습니까?"
//            PPAlert.present(inVC: self, title: title, message: HSTR("입력한 사유가 사라집니다."), actions: actions)
//            return
//        }
        btn_Delay.isSelected = false
        btn_Problem.isSelected = false
        btn_Custom.isSelected = false
        sender.isSelected = true
        
        if sender == btn_Custom {
            v_TvBg.alpha = 1
            tv_Contents.becomeFirstResponder()
        } else {
            v_TvBg.alpha = 0.3
            tv_Contents.resignFirstResponder()
        }
    }
}

extension ChangeDateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        goSelectedType(btn_Custom)
    }
}

extension ChangeDateViewController: UMInputBarDelegate {
    func didSelected() {
        if btn_Delay.isSelected == false &&
            btn_Problem.isSelected == false &&
            btn_Custom.isSelected == false {
            PPAlert.present(title: "사유를 선택해 주세요.")
            return
        }
        if btn_Custom.isSelected && tv_Contents.text.count <= 0 {
            PPAlert.present(title: "사유를 입력해 주세요.")
            return
        }
        
        var actions: [UMAction] = []
        actions.append(UMAction(title: HSTR("comm.yes"), style: .confirm, handler: {
            self.reqAPI()
        }))
        actions.append(UMAction(title: HSTR("comm.no"), style: .cancel, handler: {
        }))
        let title = "\(newDate.string(fmt: "MM월 dd일"))로 도착일 변경을\n요청하시겠습니까?"
        PPAlert.present(inVC: self, title: title, message: HSTR("담당자 확인 후 변경이 완료됩니다."), actions: actions)
    }
}
