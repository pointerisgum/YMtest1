//
//  Util.swift
//  Lulla
//
//  Created by 김영민 on 2021/04/14.
//

import Foundation
import Lightbox
import Photos

final class Util {
    
    static let shared = Util()

//    func showImage(vc: UIViewController, images: [LightboxImage], startIndex: Int = 0, delegate: LightboxControllerSaveDelegate? = nil) {
//        DispatchQueue.main.async {
//            let controller = LightboxController(images: images, startIndex: startIndex)
//            controller.saveDelegate = delegate
//            controller.dynamicBackground = true
//            vc.present(controller, animated: true)
//        }
//    }
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
}

