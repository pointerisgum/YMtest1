//
//  IntroViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2021/12/28.
//

import UIKit

extension IntroViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Intro", bundle: nil)
}

class IntroViewController: UMLoginViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        switching(to: .main)
//        switching(to: .login)
        if MData.shared.accessToken != nil && MData.shared.loginId.count > 0 && MData.shared.password.count > 0 {
            login(id: MData.shared.loginId, pw: MData.shared.password) { statusCode in
                switch statusCode {
                case .success:
                    self.switching(to: .main)
                case .error(msg: let msg):
                    self.switching(to: .login)
                    PPAlert.present(title: msg)
                }
            }
        } else {
            switching(to: .login)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func test(_ sender: Any) {
        SVProgressHUD.dismiss()

    }
}
