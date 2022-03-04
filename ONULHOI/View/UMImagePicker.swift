//
//  UMImagePicker.swift
//  Lulla
//
//  Created by Mac on 2018. 2. 23..
//  Copyright © 2018년 pplus. All rights reserved.
//

import UIKit
import Photos
import TLPhotoPicker
import MobileCoreServices

// MARK: - UMImagePicker

extension UMImagePicker {
	
    enum MediaType {
        case image
        case video
    }
    
	enum Result {
		case done([TLPHAsset]?)
		case cancel
		case delete
	}
	
    enum CameraResult {
        case cameraDone(MediaType, UIImage?, NSURL?)
        case cancel
        case delete
    }
}

final class UMImagePicker: NSObject {
	
	static let shared = UMImagePicker()
	
    fileprivate var handler: ((Result) -> Void)?
    fileprivate var cameraHandler: ((CameraResult) -> Void)?

    func excuteCamera(_ inVC: UIViewController, handler: @escaping ((CameraResult) -> Void)) {
        
        self.cameraHandler = handler

        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            self.showCamera(inVC)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    DispatchQueue.main.async { self.showCamera(inVC) }
                } else {
                    DispatchQueue.main.async {
                        self.showPermissionPopUp(inVC, msg: HSTR("카메라를 사용하기 위해 카메라 접근 권한을\n허용해 주세요."))
                    }
                }
            })
        }
    }
    
    func execute(_ inVC: UIViewController, previousImage: UIImage? = nil, selectCnt: Int = 5, allowedVideo: Bool? = true, handler: @escaping ((Result) -> Void)) {
        //allowedVideo = true: 비디오 허용, false: 비디오 허용 안함
        
		self.handler = handler
		
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            self.showAlbum(inVC, cnt: selectCnt, allowedVideo: allowedVideo)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                if newStatus == .authorized {
                    DispatchQueue.main.async { self.showAlbum(inVC, cnt: selectCnt, allowedVideo: allowedVideo) }
                } else {
                    DispatchQueue.main.async {
                        self.showPermissionPopUp(inVC, msg: HSTR("사진첩을 사용하기 위해 사진 접근 권한을\n허용해 주세요."))
                    }
                }
            })
        case .restricted, .denied:
            self.showPermissionPopUp(inVC, msg: HSTR("사진첩을 사용하기 위해 사진 접근 권한을\n허용해 주세요."))
        default: ()
        }

        
        
//		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        alert.addAction(UIAlertAction(title: HSTR("imagePicker.camera"), style: .default) { (action) in
//            alert.dismiss(animated: true)
//
//            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
//                self.showCamera(inVC)
//            } else {
//                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
//                    if granted {
//                        DispatchQueue.main.async { self.showCamera(inVC) }
//                    } else {
//                        DispatchQueue.main.async {
//                            self.showPermissionPopUp(inVC, msg: HSTR("카메라를 사용하기 위해 카메라 접근 권한을\n허용해 주세요."))
//                        }
//                    }
//                })
//            }
//        })
//
//        alert.addAction(UIAlertAction(title: HSTR("imagePicker.album"), style: .default) { (action) in
//			alert.dismiss(animated: true)
//
//            let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
//            switch photoAuthorizationStatus {
//            case .authorized:
//                self.showAlbum(inVC)
//            case .notDetermined:
//                PHPhotoLibrary.requestAuthorization({
//                    (newStatus) in
//                    if newStatus == .authorized {
//                        DispatchQueue.main.async { self.showAlbum(inVC) }
//                    } else {
//                        DispatchQueue.main.async {
//                            self.showPermissionPopUp(inVC, msg: HSTR("사진첩을 사용하기 위해 사진 접근 권한을\n허용해 주세요."))
//                        }
//                    }
//                })
//            case .restricted, .denied:
//                self.showPermissionPopUp(inVC, msg: HSTR("사진첩을 사용하기 위해 사진 접근 권한을\n허용해 주세요."))
//            default: ()
//            }
//		})
//
//        if let _ = previousImage {
//            alert.addAction(UIAlertAction(title: HSTR("comm.delete"), style: .destructive) { (action) in
//                self.handler?(Result.delete)
//            })
//        }
//
//		alert.addAction(UIAlertAction(title: HSTR("comm.cancel"), style: .cancel) { (action) in
//			alert.dismiss(animated: true)
//
//            self.handler?(Result.cancel)
//		})
//
//		inVC.present(alert, animated: true)
	}
	
	func done(_ assets: [TLPHAsset]?) {
        self.handler?(Result.done(assets))
	}
    
    func cameraDone(_ mediaType: MediaType, image: UIImage?, videoUrl: NSURL?) {
//        self.cameraHandler?(Result.done(assets))
        self.cameraHandler?(CameraResult.cameraDone(mediaType, image, videoUrl))
//        self.cameraHandler?(asset)
    }

    func showCamera(_ inVC: UIViewController) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.cameraDevice = .rear
        vc.mediaTypes = ["public.image", "public.movie"]
        vc.delegate = self
        vc.allowsEditing = true
        inVC.present(vc, animated: true)
    }
    
    func showAlbum(_ inVC: UIViewController, cnt: Int, allowedVideo: Bool? = true) {
//        let vc = UIImagePickerController()
//        vc.sourceType = .photoLibrary
//        vc.allowsEditing = true
//        vc.delegate = self
//        inVC.present(vc, animated: true)
        let viewController = TLPhotosPickerViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.delegate = self
        var configure = TLPhotosPickerConfigure()
        if let allowedVideo = allowedVideo {
            configure.allowedVideo = allowedVideo
            configure.allowedVideoRecording = allowedVideo
        }
        #if DEBUG
        configure.maxSelectedAssets = 50
        #else
        configure.maxSelectedAssets = cnt
        #endif
        viewController.configure = configure
        
        //configure.nibSet = (nibName: "CustomCell_Instagram", bundle: Bundle.main) // If you want use your custom cell..
        viewController.handleNoAlbumPermissions = { [weak self] (picker) in
            let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
            switch photoAuthorizationStatus {
            case .authorized:
                self?.showAlbum(inVC, cnt: cnt)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({
                    (newStatus) in
                    if newStatus == .authorized {
                        DispatchQueue.main.async { self?.showAlbum(inVC, cnt: cnt) }
                    } else {
                        DispatchQueue.main.async {
                            self?.showPermissionPopUp(inVC, msg: HSTR("사진첩을 사용하기 위해 사진 접근 권한을\n허용해 주세요."))
                        }
                    }
                })
            case .restricted, .denied:
                self?.showPermissionPopUp(inVC, msg: HSTR("사진첩을 사용하기 위해 사진 접근 권한을\n허용해 주세요."))
            default: ()
            }
        }
        viewController.handleNoCameraPermissions = { [weak self] (picker) in
            
            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                self?.showAlbum(inVC, cnt: cnt)
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    DispatchQueue.main.async {
                        if granted {
                            self?.showAlbum(inVC, cnt: cnt)
                        } else {
                            viewController.dismiss(animated: true) {
                                self?.showPermissionPopUp(inVC, msg: HSTR("카메라를 사용하기 위해 카메라 접근 권한을\n허용해 주세요."))
                            }
                        }
                    }
//                    if granted {
//                        DispatchQueue.main.async { self?.showAlbum(inVC) }
//                    } else {
//                        DispatchQueue.main.async {
//                            viewController.dismiss(animated: true) {
//                                self?.showPermissionPopUp(inVC, msg: HSTR("카메라를 사용하기 위해 카메라 접근 권한을\n허용해 주세요."))
//                            }
//                        }
//                    }
                })
            }
        }
        inVC.present(viewController, animated: true, completion: nil)
    }
    
    func showPermissionPopUp(_ inVC: UIViewController, msg: String) {
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
        PPAlert.present(title: msg, actions: actions)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

//extension UMImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//// Local variable inserted by Swift 4.2 migrator.
//let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//
//		let image: UIImage? = {
//			if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
//				return image
//			} else {
//				return info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
//			}
//		}()
//
//		if let image = image {
//			picker.dismiss(animated: true)
//			self.done(image)
//		}
//	}
//
//}

extension UIImage {
	
	func resizingImageForUploading() -> UIImage? {
		guard self.size.width > 0 && self.size.height > 0 else {
			return self
		}
		
		let size = CGFloat(1280)
		var ratio = CGFloat(1)
		
		if self.size.width > self.size.height {
			ratio = size/self.size.width
		} else {
			ratio = size/self.size.height
		}
		
		let newSize = CGSize(width: self.size.width*ratio, height: self.size.height*ratio)
		
		return self.imageScaled(to: newSize)
	}
	
	private func imageScaled(to size: CGSize) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, self.af_isOpaque, 1)
		draw(in: CGRect(origin: CGPoint.zero, size: size))
		
		let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		return scaledImage
	}
	
}

extension UMImagePicker: TLPhotosPickerViewControllerDelegate {
    //TLPhotosPickerViewControllerDelegate
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        // use selected order, fullresolution image
        done(withTLPHAssets)
//        self.selectedAssets = withTLPHAssets
    return true
    }
    
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
        // if you want to used phasset.
    }
    
    func photoPickerDidCancel() {
        // cancel
    }
    func dismissComplete() {
        // picker viewcontroller dismiss completion
    }
    func canSelectAsset(phAsset: PHAsset) -> Bool {
        //Custom Rules & Display
        //You can decide in which case the selection of the cell could be forbidden.
        return true
    }
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        //선택 최대값 초과
        
    }
//    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
//        // handle denied albums permissions case
//        print("1")
//    }
//    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
//        // handle denied camera permissions case
//        print("2")
//    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}


extension UMImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard info[UIImagePickerController.InfoKey.mediaType] != nil else { return }
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
        switch mediaType {
        case kUTTypeMovie:
            let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as! NSURL?
            let pathString = videoUrl?.relativePath
            self.cameraDone(.video, image: nil, videoUrl: videoUrl)
            break
        default:
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.cameraDone(.image, image: editedImage, videoUrl: nil)
            }
            break
        }


        picker.dismiss(animated: true)
    }
    
}
