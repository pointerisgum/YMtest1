//
//  UMLoginViewController.swift
//  Lulla
//
//  Created by 김영민 on 2021/03/02.
//

import UIKit
import CryptoKit

class UMLoginViewController: UMViewController, IValidate, ISwitchingVC {

    enum StatusCode {
        case success
        case error(msg: String)
    }
    
    var completeHandler: (StatusCode) -> Void = { _ in }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func login(id: String!, pw: String!, handler: @escaping ((_ statusCode: StatusCode) -> Void))  {
        
        
//        var sender = MRest.Sender(path: .login, urlType: .empty)
//        sender.parameters[Keys.id] = id
//        sender.parameters[Keys.password] = pw
//        MRest.shared.request(sender) { (resp: MRest.Resp<NABase>) in
//            guard resp.code == .success else {
//                return
//            }
//
////            guard let item = resp.object.row else { return }
////
////            MData.shared.id = id
////            MData.shared.pw = pw
////
////            if let name = item.name {
////                MData.shared.name = name
////            }
////
////            if let name = item.userImageUrl {
////                MData.shared.userImageUrl = name
////            }
////
////            MData.shared.lastLogin = Date().string(fmt: "yyyy-MM-dd HH:mm:ss")
////
////            self.switching(to: .main)
//        }
        
//        MData.shared.accessToken = nil

        var sender = MRest.Sender(path: .login, urlType: .empty)
//        sender.object = {
//            let object = NDLogin()
//            object.businessRegistrationNumber = "5454534534"
//            object.password = "111111"
//            return object
//        }()
        sender.parameters[Keys.id] = id
        sender.parameters[Keys.password] = pw
        MRest.shared.request(sender) { (resp: MRest.Resp<NARow<NDLogin>>) in
            guard resp.code == .success else {
                handler(.error(msg: resp.message))
                return
            }

            guard let item = resp.object.row else { return }
            
            if let token = item.token {
                MData.shared.accessToken = "Bearer " + token
            }
            
            MData.shared.id = item.id ?? ""
            MData.shared.loginId = id
            MData.shared.password = pw

            handler(.success)

//            MData.shared.id = id
//            MData.shared.pw = pw
//
//            if let name = item.name {
//                MData.shared.name = name
//            }
//
//            if let name = item.userImageUrl {
//                MData.shared.userImageUrl = name
//            }
//
//            MData.shared.lastLogin = Date().string(fmt: "yyyy-MM-dd HH:mm:ss")
//
//            self.switching(to: .main)
        }

    }

    private func sha256(_ string: String, salt: String) -> String {
        let salt = salt + string
        let saltData = salt.data(using: .utf8)
        let sha256Salt = SHA256.hash(data: saltData!)
        var shaData = Data()
        _ = sha256Salt.compactMap { indata in
            shaData.append(indata)
        }
        return shaData.base64EncodedString()
    }
}
