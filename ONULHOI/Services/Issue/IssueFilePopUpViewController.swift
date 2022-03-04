//
//  IssueFilePopUpViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/10.
//

import UIKit
import BMPlayer

extension IssueFilePopUpViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Issue", bundle: nil)
}

class IssueFilePopUpViewController: UMViewController {

    @IBOutlet weak var lb_Title: UILabel!
    @IBOutlet weak var iv_Thumb: UIImageView!
    @IBOutlet weak var v_VideoType: UIView!
    
    var stringFormat: String.StringFormat!
    var imageUrlString: String!
    var videoUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        switch stringFormat! {
        case .image:
            iv_Thumb.m_setImage(withURLString: imageUrlString)
            lb_Title.text = HSTR("이미지")
            v_VideoType.isHidden = true
        case .video:()
            lb_Title.text = HSTR("동영상")
            if let videoUrl = videoUrl {
                IssueDetailListFileViewController.getThumbnailImageFromVideoUrl(url: videoUrl) { (thumbImage) in
                    self.iv_Thumb.image = thumbImage
                }
            }
            v_VideoType.isHidden = false
        case .unowned:()
            
        }

        
//        BMPlayerConf.topBarShowInCase = .horizantalOnly
//
//        BMPlayerConf.shouldAutoPlay = false
//
//        let player = BMPlayer()
//
//
////        player.setImage(url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!)
//        let asset = BMPlayerResource(url: videoUrl)
//        player.setVideo(resource: asset)
////        player.pause()
//
//        v_VideoBg.addSubview(player)
//
//
//        player.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
////            make.top.bottom.left.right.equalTo(self.v_VideoBg)
//            // Note here, the aspect ratio 16:9 priority is lower than 1000 on the line, because the 4S iPhone aspect ratio is not 16:9
////            make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(750)
//        }
//        // Back button event
//        player.backBlock = { [unowned self] (isFullScreen) in
//            if isFullScreen == true { return }
//            let _ = self.navigationController?.popViewController(animated: true)
//        }
    }
    
    @IBAction func goVideoPlay(_ sender: Any) {
//        BMPlayerConf.topBarShowInCase = .horizantalOnly
//        BMPlayerConf.shouldAutoPlay = false

        if let videoUrl = videoUrl {
            let player = BMPlayer()
            let asset = BMPlayerResource(url: videoUrl)
            player.setVideo(resource: asset)
            view.addSubview(player)

            player.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }

            player.backBlock = { isFullScreen in
                player.removeFromSuperview()
            }
        }
    }
}
