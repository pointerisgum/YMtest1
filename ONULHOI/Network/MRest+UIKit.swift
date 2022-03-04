//
//  MRest+UIKit.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 1..
//  Copyright © 2017년 Mac. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

extension UIImageView {
	
	func m_setImage(
		withURLString string: String?,
		placeholderImage: UIImage? = nil,
        filter: ImageFilter? = nil,
		progress: AlamofireImage.ImageDownloader.ProgressHandler? = nil,
		progressQueue: DispatchQueue = .main,
        imageTransition: UIImageView.ImageTransition = .noTransition,
		runImageTransitionIfCached: Bool = true,
		animated: Bool = false,
        showPlayButton: Bool = false,
		completion: ((Alamofire.DataResponse<UIImage>) -> Void)? = nil) {
		af_cancelImageRequest()
        clipsToBounds = true
        
        if let playButton = viewWithTag(999) {
            playButton.removeFromSuperview()
        }
        //        subviews.forEach({$0.removeFromSuperview()})
        
		guard let string = string, let url = URL(string: string) else {
			image = placeholderImage
			
			let error = AFIError.requestCancelled
			let response = DataResponse<UIImage>(request: nil, response: nil, data: nil, result: .failure(error))
			completion?(response)
			return
		}
		
        if showPlayButton {
            let playImage = UIImage(named: "play")
            let playImageView = UIImageView(image: playImage)
            playImageView.tag = 999
            addSubview(playImageView)
            playImageView.translatesAutoresizingMaskIntoConstraints = false
            playImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
            playImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        }

		guard animated else {
			af_setImage(withURL: url, placeholderImage: placeholderImage, filter: filter, progress: progress, progressQueue: progressQueue, imageTransition: imageTransition, runImageTransitionIfCached: runImageTransitionIfCached, completion: completion)
			return
		}
		
		let urlRequest = URLRequest(url: url)
		var unCached = true
		let imageDownloader = af_imageDownloader ?? UIImageView.af_sharedImageDownloader
		let imageCache = imageDownloader.imageCache
		if let _ = imageCache?.image(for: urlRequest, withIdentifier: filter?.identifier) {
			unCached = false
		}
		        
		af_setImage(withURL: url, placeholderImage: placeholderImage, filter: filter, progress: progress, progressQueue: progressQueue, imageTransition: imageTransition, runImageTransitionIfCached: runImageTransitionIfCached) { resp in
			defer { completion?(resp) }
			
			guard resp.result.isSuccess else {
				self.image = placeholderImage
				return
			}
			
			if unCached {
				self.alpha = 0
				self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
				UIView.animate(withDuration: 0.25) {
					self.alpha = 1
					self.transform = CGAffineTransform.identity
				}
			}
		}
	}
	
}

extension UIButton {
	
	func m_setImage(
		withURLString string: String?,
		state: UIControl.State = .normal,
		placeholderImage: UIImage? = nil,
		filter: ImageFilter? = nil,
		progress: AlamofireImage.ImageDownloader.ProgressHandler? = nil,
		progressQueue: DispatchQueue = .main,
		completion: ((Alamofire.DataResponse<UIImage>) -> Void)? = nil) {
		guard let string = string, let url = URL(string: string) else {
			let error = AFIError.requestCancelled
			let response = DataResponse<UIImage>(request: nil, response: nil, data: nil, result: .failure(error))
			completion?(response)
			return
		}
		
		af_setImage(for: state, url: url, placeholderImage: placeholderImage, filter: filter, progress: progress, progressQueue: progressQueue, completion: completion)
	}
	
	func m_setBackgroundImage(
		withURLString string: String?,
		state: UIControl.State = .normal,
		placeholderImage: UIImage? = nil,
		filter: ImageFilter? = nil,
		progress: AlamofireImage.ImageDownloader.ProgressHandler? = nil,
		progressQueue: DispatchQueue = .main,
		completion: ((Alamofire.DataResponse<UIImage>) -> Void)? = nil) {
		guard let string = string, let url = URL(string: string) else {
			let error = AFIError.requestCancelled
			let response = DataResponse<UIImage>(request: nil, response: nil, data: nil, result: .failure(error))
			completion?(response)
			return
		}
		
		af_setBackgroundImage(for: state, url: url, placeholderImage: placeholderImage, filter: filter, progress: progress, progressQueue: progressQueue, completion: completion)
	}
	
}
