//
//  MyPageViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/05.
//

import UIKit

extension MyPageViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Home", bundle: nil)
}

class MyPageViewController: UMBaseViewController, ISwitchingVC {

    @IBOutlet weak var lb_CompanyName: UILabel!
    @IBOutlet weak var lb_BusinessNo: UILabel!
    @IBOutlet weak var lb_Name: UILabel!
    @IBOutlet weak var lb_Phone: UILabel!
    @IBOutlet weak var lb_Email: UILabel!
    @IBOutlet weak var lb_Banking: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reload()
    }
    
    func reload() {
        let sender = MRest.Sender(path: .myPage, method: .get)
        MRest.shared.request(sender) { (resp: MRest.Resp<NARow<NDMy>>) in
            guard resp.code == .success else {
                return
            }

            guard let item = resp.object.row else { return }
            
            self.lb_CompanyName.text = item.businessName?.count ?? 0 <= 0 ? "-" : item.businessName
            self.lb_BusinessNo.text = item.businessRegistrationNumber?.count ?? 0 <= 0 ? "-" : item.businessRegistrationNumber
            self.lb_Name.text = item.representName?.count ?? 0 <= 0 ? "-" : item.representName
            self.lb_Phone.text = item.representPhoneNumber?.count ?? 0 <= 0 ? "-" : item.representPhoneNumber
            self.lb_Email.text = item.representEmail?.count ?? 0 <= 0 ? "-" : item.representEmail
            self.lb_Banking.text = item.bankInfo?.count ?? 0 <= 0 ? "-" : item.bankInfo
        }
    }

    @IBAction func goChangePw(_ sender: Any) {
        let vc = ChangePwViewController.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goLogOut(_ sender: Any) {
        var actions: [UMAction] = []
        actions.append(UMAction(title: HSTR("comm.confirm"), style: .confirm, handler: {
            MData.shared.accessToken = nil
            MData.shared.id = ""
            MData.shared.password = ""
            self.switching(to: .login)
        }))
        actions.append(UMAction(title: HSTR("comm.cancel"), style: .cancel, handler: {

        }))
        PPAlert.present(inVC: self, title: HSTR("로그아웃"), message: HSTR("로그아웃 하시겠습니까?"), actions: actions)
    }    
}
