//
//  PHAsset+PP.swift
//  Lulla
//
//  Created by 김영민 on 2020/12/28.
//

//import UIKit
//import Foundation
import Photos

extension PHAsset {
    enum ImageType {
        case thumb
        case original
    }
    
    var primaryResource: PHAssetResource? {
        let types: Set<PHAssetResourceType>

        switch mediaType {
        case .video:
            types = [.video, .fullSizeVideo]
        case .image:
            types = [.photo, .fullSizePhoto]
        case .audio:
            types = [.audio]
        case .unknown:
            types = []
        @unknown default:
            types = []
        }

        let resources = PHAssetResource.assetResources(for: self)
        let resource = resources.first { types.contains($0.type)}

        return resource ?? resources.first
    }

    var originalFilename: String {
        guard let result = primaryResource else {
            return "file"
        }

        return result.originalFilename
    }

    func getImageToAsset(asset: PHAsset?, size: CGSize = PHImageManagerMaximumSize, type: ImageType = .thumb) -> UIImage? {
        //        var images:[UIImage] = []
        
        guard let phAsset = asset else { return nil }
        
        var reqImage: UIImage?
        let requestOptions = PHImageRequestOptions()
//        if type == .original {
//            requestOptions.resizeMode = PHImageRequestOptionsResizeMode.exact
//            requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
//        } else {
//            requestOptions.resizeMode = PHImageRequestOptionsResizeMode.fast
//            requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.fastFormat
//        }
        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.exact
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat

        requestOptions.isNetworkAccessAllowed = true
        requestOptions.isSynchronous = true
        
        if phAsset.mediaType == PHAssetMediaType.image || phAsset.mediaType == PHAssetMediaType.video {
            PHImageManager.default().requestImage(for: phAsset,
                                                  targetSize: type == .original ? PHImageManagerMaximumSize : size,
                                                  contentMode: type == .original ? PHImageContentMode.default : PHImageContentMode.aspectFill,
                                                  options: requestOptions) { (image, info) in
                if let image = image {
                    reqImage = image
                } else {
                    print("get image from asset failed")
                }
            }
        }
        
        return reqImage
    }
    
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)) {
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
    
    func getVideoThumb() -> UIImage? {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        option.isNetworkAccessAllowed = true
        var thumbnail = UIImage()
        manager.requestImage(for: self, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
}
