//
//  IValidation.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 19..
//  Copyright © 2017년 pplus. All rights reserved.
//

import UIKit

enum ValidateType {
	case loginId
	case password
    case confirmPassword
    case tempPassword
//	case newPassword
	case mobile
	case certNum
	case name
	case nickname
	case birthday
	case email
    case empty
    case tel
    case role               //역할
}

protocol IValidate {
    func validate(_ type: ValidateType, text: String?, msg: String?, alert: Bool) -> (isValid: Bool, text: String?)
}

extension IValidate where Self: UIViewController {
	
	var passswordMaxLen: Int {
		return 15
	}
	
	private func showAlert(_ alert: Bool, message: String) {
		if alert {
            PPAlert.present(inVC: self, title: message)
		}
	}
	
    func validate(_ type: ValidateType, text: String?, msg: String? = nil, alert: Bool = true) -> (isValid: Bool, text: String?) {
		switch type {
		case .loginId:
			guard let text = text, text.count > 0 else {
				let message = HSTR("validate.loginId.empty")
				showAlert(alert, message: message)
				return (isValid: false, text: message)
			}
            //validate.tempPwd.empty
        case .tempPassword:
            guard let text = text, text.count > 0 else {
                let message = HSTR("validate.tempPwd.empty")
                showAlert(alert, message: message)
                return (isValid: false, text: message)
            }
		case .password:
			guard let text = text, text.count > 0 else {
				let message = HSTR("validate.pwd.empty")
				showAlert(alert, message: message)
				return (isValid: false, text: message)
			}
			guard text.count >= 6 else {
				let message = HSTR("validate.pwd.invalid")
				showAlert(alert, message: message)
				return (isValid: false, text: message)
			}
            guard isValidPassword(password: text) else {
                let message = HSTR("validate.pwd.invalid")
                showAlert(alert, message: message)
                return (isValid: false, text: message)
            }
//		case .newPassword:
//			guard let text = text, text.count > 0 else {
//				let message = HSTR("validate.newPwd.empty")
//				showAlert(alert, message: message)
//				return (isValid: false, text: message)
//			}
//			guard text.count >= 6 else {
//				let message = HSTR("validate.newPwd.invalid")
//				showAlert(alert, message: message)
//				return (isValid: false, text: message)
//			}
//            guard isValidPassword(password: text) else {
//                let message = HSTR("validate.pwd.invalid")
//                showAlert(alert, message: message)
//                return (isValid: false, text: message)
//            }
		case .confirmPassword:
			guard let text = text, text.count > 0 else {
				let message = HSTR("validate.confirmPwd.empty")
				showAlert(alert, message: message)
				return (isValid: false, text: message)
			}
		case .mobile:
			guard let text = text, text.count > 0 else {
				let message = HSTR("validate.mobile.empty")
				showAlert(alert, message: message)
				return (isValid: false, text: message)
			}
			guard text.count > 9 else {
				let message = HSTR("validate.mobile.invalid")
				showAlert(alert, message: message)
				return (isValid: false, text: message)
			}
            guard text.hasPrefix("01") else {
                let message = HSTR("validate.mobile.invalid")
                showAlert(alert, message: message)
                return (isValid: false, text: message)
            }
		case .certNum:
			guard let text = text, text.count > 0 else {
				let message = HSTR("validate.certNum.empty")
				showAlert(alert, message: message)
				return (isValid: false, text: message)
			}
			guard text.toInt() != nil, text.count >= 4 else {
				let message = HSTR("validate.certNum.invalid")
				showAlert(alert, message: message)
				return (isValid: false, text: message)
			}
		case .name:
			guard let text = text, text.count > 0 else {
				let message = HSTR("validate.name.empty")
				showAlert(alert, message: message)
				return (isValid: false, text: message)
			}
		case .nickname:
			guard let text = text, text.count > 0 else {
				let message = HSTR("validate.nickname.empty")
				showAlert(alert, message: message)
				return (isValid: false, text: message)
			}
			guard text.count >= 2, text.count <= 20 else {
				let message = HSTR("validate.nickname.invalid")
				showAlert(alert, message: message)
				return (isValid: false, text: message)
			}
		case .birthday:
			guard let text = text, text.count > 0 else {
				let message = HSTR("validate.birthday.empty")
				showAlert(alert, message: message)
				return (isValid: false, text: message)
			}
			guard text.count == 8 else {
				let message = HSTR("validate.birthday.invalid")
				showAlert(alert, message: message)
				return (isValid: false, text: message)
			}
		case .email:
			guard let text = text, text.count > 0 else {
				let message = HSTR("validate.email.empty")
				showAlert(alert, message: message)
				return (isValid: false, text: message)
			}
			let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
			guard NSPredicate(format:"SELF MATCHES %@", regEx).evaluate(with: text) else {
				let message = HSTR("validate.email.invalid")
				self.showAlert(alert, message: message)
				return (isValid: false, text: message)
			}
        case .empty:
            guard let text = text, text.count > 0 else {
                if let msg = msg {
                    showAlert(alert, message: msg)
                }
                return (isValid: false, text: msg)
            }
        case .tel:
            guard let text = text, text.count > 0 else {
                let message = HSTR("validate.tel.empty")
                showAlert(alert, message: message)
                return (isValid: false, text: message)
            }
            guard text.count > 7 else {
                let message = HSTR("validate.tel.invalid")
                showAlert(alert, message: message)
                return (isValid: false, text: message)
            }
        case .role:
            guard let text = text, text.count > 0 else {
                let message = HSTR("validate.role.empty")
                showAlert(alert, message: message)
                return (isValid: false, text: message)
            }
        }
		
		return (isValid: true, text: text)
	}
	
    func isValidEmail(email: String) -> Bool {
        let ex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", ex)
        return predicate.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
//        let ex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])(?=.*[0-9])[A-Za-z\\d$@$!%*?&]{8}"
//        let ex = "^(?!(?:[0-9]+)$)([a-zA-Z]|[0-9a-zA-Z]){8,20}$"
        let ex = "(?=.*[A-Za-z])(?=.*[0-9]).{6,15}" //영문, 숫자 포함 6~15자
        let predicate = NSPredicate(format:"SELF MATCHES %@", ex)
        return predicate.evaluate(with: password)
    }
}
