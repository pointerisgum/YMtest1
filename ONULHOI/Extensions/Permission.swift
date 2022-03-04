//
//  Permission.swift
//  Lulla
//
//  Created by 김영민 on 2021/01/07.
//

import Foundation
import Photos
import UIKit

enum PermissionType {
    case image
    case camera
}


final class Permission: NSObject {
    
    static let shared = Permission()

    func permissionAsk(askType: PermissionType, handler:@escaping ((_ success:Bool) -> Void)) {
        
        switch askType {
        case .image:
            let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
            switch photoAuthorizationStatus {
            case .authorized:
                handler(true)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({
                    (newStatus) in
                    if newStatus == .authorized {
                        handler(true)
                    } else {
                        DispatchQueue.main.async {
                            self.showMessage(message: "사진첩을 사용하기 위해 사진 접근 권한을\n허용해 주세요.")
                        }
                        handler(false)
                    }
                })
            case .restricted, .denied:
                DispatchQueue.main.async {
                    self.showMessage(message: "사진첩을 사용하기 위해 사진 접근 권한을\n허용해 주세요.")
                }
                handler(false)
            default: ()
            }
        case .camera:
            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                handler(true)
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        //                    DispatchQueue.main.async {
                        //                    }
                        handler(true)
                    } else {
                        DispatchQueue.main.async {
                            self.showMessage(message: HSTR("카메라를 사용하기 위해 카메라 접근 권한을\n허용해 주세요."))
                        }
                        handler(false)
                    }
                })
            }
        }
    }
    
    private func showMessage(message: String) {
        var actions: [UMAction] = []
        actions.append(UMAction(title: HSTR("comm.setting"), handler: {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    
                })
            }
        }))
        actions.append(UMAction(title: HSTR("comm.cancel"), style: .cancel, handler: { 

        }))
        PPAlert.present(title: message, actions: actions)
    }
}
