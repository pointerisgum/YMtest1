//
//  URL+M.swift
//  Lulla
//
//  Created by 김영민 on 2021/01/07.
//

import Foundation
import Photos

extension URL {
    
    enum UrlType {
        case image
        case video
    }
    
    func albumSave(urlType: UrlType = .image, complete:((_ success:Bool) -> Void)? = nil) {
        Permission.shared.permissionAsk(askType: .image) { (ok) in
            if ok {
                switch urlType {
                case .image:
                    do {
                        let imageData = try Data(contentsOf: self)
                        let image = UIImage(data: imageData)
                        if let image = image {
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.creationRequestForAsset(from: image)
                            }) { saved, error in
                                DispatchQueue.main.async {
                                    if saved == true {
                                        complete?(true)
                                    } else {
                                        complete?(false)
                                    }
                                }
                            }
                        }
                    } catch {
                        complete?(false)
                    }
                case .video:
                    let session = URLSession.shared
                    let task = session.dataTask(with: self) { data, response, error in
                        if error != nil {
                            complete?(false)
                            return
                        }
                        guard let videoData = data else {
                            complete?(false)
                            return
                        }
                        
                        let savePathUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp.mp4")
                        try? FileManager.default.removeItem(at: savePathUrl)
                        DispatchQueue.global(qos: .background).async {
                            do {
                                try videoData.write(to: savePathUrl, options: .atomic)
                                PHPhotoLibrary.shared().performChanges({
                                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: savePathUrl)
                                }) { saved, error in
                                    DispatchQueue.main.async {
                                        if saved == true {
                                            try? FileManager.default.removeItem(at: savePathUrl)
                                            complete?(true)
                                        } else {
                                            complete?(false)
                                        }
                                    }
                                }
                            } catch {
                                complete?(false)
                            }
                        }
                    }
                    task.resume()
                }
            }
        }
    }
}
