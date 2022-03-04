//
//  MRest+Upload.swift
//  Lulla
//
//  Created by Mac on 2018. 3. 20..
//  Copyright © 2018년 pplus. All rights reserved.
//

import Foundation
import Alamofire
import Photos

extension MRest {
    
}

extension MRest {
    
    enum MultipleResult {
        case inProcess(progress: (total: Int, completed: Int, failed: Int))
        case failure
        case complete
    }

    typealias Handler = (_ success: Bool, _ file: NDFile?) -> ()
    typealias MultipleHandler = (_ result: MultipleResult, _ file: [NDFile]) -> ()
}

extension MRest {
	
    class func upload(file: NDFile?, index: Int? = 0, length: Int? = 0, handler: Handler?) {
		
        guard let data = file?.fileData else {
            handler?(false, nil)
            return
        }
        
		let url = PPCST.Rest.baseURL + PPCST.Rest.apiUri + MRest.Path.file.rawValue
		
        NETLog("[Request] \("업로드") \(String(describing: data.count))")
		
		var headers = HTTPHeaders()
		headers["authorization"] = MData.shared.accessToken
		
		var parameters = Parameters()
//        parameters[Keys.member_id] = MData.shared.memberId
//        parameters[Keys.index] = "\(index ?? 0)"

        var mimeType = "image/jpg"
        var fileName = UUID().uuidString
        switch file?.type {
        case .image:
//            parameters[Keys.width] =  "\(file?.width ?? 0)"
//            parameters[Keys.height] = "\(file?.height ?? 0)"
            fileName.append(".jpg")
        case .video:
//            parameters[Keys.duration] =  "\(file?.duration ?? 0)"
            fileName.append(".mov")
            mimeType = "video/mp4"          //mp4
//            mimeType = "video/quicktime"    //mov
//            mimeType = "video/mpeg"
        default: ()
        }

		Alamofire.upload(multipartFormData: { multipartFormData in
			parameters.forEach({ (key, value) in
				if let value = value as? String, let data = value.data(using: .utf8) {
					multipartFormData.append(data, withName: key)
				}
			})
			
			multipartFormData.append(data, withName: "file", fileName: fileName, mimeType: mimeType)
		}, to: url, headers: headers, encodingCompletion: { encodingResult in
			switch encodingResult {
			case .success(let upload, _, _):
				upload.validate()
				upload.responseJSON { response in
					switch response.result {
					case .success:
						NETLog("[Success] \(upload) \(response)")
						let row: NARow<NDFile> = NARow(value: response.result.value)
						handler?(row.isSuccessed, row.row)
					case .failure(let error):
						NETLog("[Failure]error: \(error)")
						handler?(false, nil)
					}
				}
			case .failure(let encodingError):
				NETLog("[Failure]encodingError: \(encodingError)")
				handler?(false, nil)
			}
		})
	}
	
}

extension MRest {
	
    class func upload(files: [NDFile], handler: MultipleHandler?) {
        
//        SVProgressHUD.show()

		var finishFiles: [NDFile] = []
		var failed = 0
		let group = DispatchGroup()
		
        for (index, element) in files.enumerated() {
            group.enter()
            MRest.upload(file: element, index: index, length: 0) { (success, file) in
                defer {
                    handler?(.inProcess(progress: (total: files.count, completed: finishFiles.count, failed: failed)), finishFiles)
                    group.leave()
                }
                
                guard success, let file = file else {
                    failed += 1
//                    SVProgressHUD.dismiss()
                    return
                }
                
                finishFiles.append(file)
            }
        }
		
		group.notify(queue: .main) {
			if files.count == finishFiles.count {
				handler?(.complete, finishFiles)
			} else {
				handler?(.failure, finishFiles)
			}
//            SVProgressHUD.dismiss()
		}
	}
    
    func compressVideo(inputURL: URL,
                       outputURL: URL,
                       handler:@escaping (_ exportSession: AVAssetExportSession?) -> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset,
                                                       presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            return
        }

        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mov
        exportSession.exportAsynchronously {
            handler(exportSession)
        }
    }
}

extension MRest {
    class func uploadImage(imageAssets: [Any], complete: MultipleHandler?) {
        DispatchQueue.global(qos: .background).async {
            var uploadData: [NDFile] = []
            imageAssets.forEach({
                if $0 is PHAsset {
                    let asset: PHAsset = $0 as! PHAsset
                    if asset.mediaType == .video {
                        let semaphore = DispatchSemaphore(value: 0)
                        let options: PHVideoRequestOptions = PHVideoRequestOptions()
                        options.version = .original
                        options.isNetworkAccessAllowed = true
                        PHImageManager.default().requestAVAsset(forVideo: asset, options: options, resultHandler: {(avAsset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                            if let urlAsset = avAsset as? AVURLAsset {
                                let localVideoUrl: URL = urlAsset.url as URL
                                let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + UUID().uuidString + ".mov")
                                MRest.shared.compressVideo(inputURL: localVideoUrl, outputURL: compressedURL) { (exportSession) in
                                    guard let session = exportSession else {
                                        return
                                    }
                                    switch session.status {
                                    case .completed:
                                        guard let compressedData = try? Data(contentsOf: compressedURL) else {
                                            return
                                        }
                                        print("File size after compression: \(Double(compressedData.count / 1048576)) mb")
                                        let file: NDFile = NDFile.init()
                                        file.fileData = compressedData
                                        file.duration = asset.duration
                                        file.type = .video
                                        uploadData.append(file)
                                        semaphore.signal()
                                    default:
                                        semaphore.signal()
                                        break
                                    }
                                }
                            } else {
                                semaphore.signal()
                            }
                        })
                        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
                    } else {
                        let image = asset.getImageToAsset(asset: asset, type: .original)
                        if let image = image {
                            let file: NDFile = NDFile.init()
                            file.fileData = image.jpegData(compressionQuality: 0)
                            file.width = Int(image.size.width)
                            file.height = Int(image.size.height)
                            file.type = .image
                            uploadData.append(file)
                        }
                    }
                } else if $0 is UIImage {
                    let image = $0 as? UIImage
                    if let image = image {
                        let file: NDFile = NDFile.init()
                        file.fileData = image.jpegData(compressionQuality: 0)
                        file.width = Int(image.size.width)
                        file.height = Int(image.size.height)
                        file.type = .image
                        uploadData.append(file)
                    }
                } else {
                    
                }
            })
            
            MRest.upload(files: uploadData) { result, files in
                if let complete = complete {
                    complete(result, files)
                }
//                switch result {
//                case .inProcess(let progress):
//                    print("progress: \(progress)")
//                case .failure: ()
//                case .complete:
//                    complete(result, files)
////                    self?.reqItem(tempMode: tempMode, afterClose: afterClose, files: files)
//                }
            }

        }
    }
}
