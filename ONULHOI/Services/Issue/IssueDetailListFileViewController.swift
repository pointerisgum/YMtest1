//
//  IssueDetailListFileViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/10.
//

import UIKit
import AlignedCollectionViewFlowLayout
import AVFoundation

extension IssueDetailListFileViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Issue", bundle: nil)
}

class IssueDetailListFileViewController: UMViewController {

    @IBOutlet weak var lb_Title: UILabel!
    @IBOutlet weak var lb_Date: UILabel!
    @IBOutlet weak var lb_ProductName: UILabel!
    @IBOutlet weak var lb_Descrip: UILabel!
    @IBOutlet weak var cv_List: UICollectionView!
    
    var naviTitle: String?
    var items: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lb_Title.text = naviTitle
        
        reload()
    }
    
    func reload() {
        var serialNumber: String?
        
        let stringArray = naviTitle?.components(separatedBy: "_")
        if stringArray?.count ?? 0 >= 3 {
            serialNumber = (stringArray?.first ?? "") + "__" + (stringArray?.last ?? "")
        }
        
        guard let serialNumber = serialNumber else { return }
        
        var sender = MRest.Sender(path: .issuesInboundInfosSerialNumber, method: .get)
        sender.customUrl = PPCST.Rest.baseURL + PPCST.Rest.apiUri + MRest.Path.issuesInboundInfosSerialNumber.rawValue +
        "?\(Keys.serialNumber)=\(serialNumber)"

        MRest.shared.request(sender) { (resp: MRest.Resp<NARow<NDIssueDetailFile>>) in
            guard resp.code == .success else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    PPAlert.present(inVC: self, title: resp.message)
                }
                return
            }

            guard let item = resp.object.row else { return }

            self.lb_Date.text = item.createdAt
            self.lb_ProductName.text = item.productName
            self.lb_Descrip.text = item.reasonDetail
            self.items = item.inboundInfoImagesList
            
            self.cv_List.reloadData()
        }
    }
}

extension IssueDetailListFileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CvFileCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.v_VideoType.isHidden = true

        let item = items?[indexPath.row]
        let stringFormat = item?.format()
        if let stringFormat = stringFormat {
            switch stringFormat {
            case .image:
                cell.iv_Thumb.m_setImage(withURLString: item)
            case .video:()
                cell.v_VideoType.isHidden = false
                if let videoUrlString = item, let url = URL(string: videoUrlString) {
                    IssueDetailListFileViewController.getThumbnailImageFromVideoUrl(url: url) { (thumbImage) in
                        cell.iv_Thumb.image = thumbImage
                    }
                }
                cell.v_VideoType.isHidden = false
            default:()
                
            }
        }

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = IssueFilePopUpViewController.instantiate()

        let item = items?[indexPath.row]
        let stringFormat = item?.format()
        if let stringFormat = stringFormat {
            switch stringFormat {
            case .image:
                vc.imageUrlString = item
            case .video:()
                if let videoUrlString = item, let url = URL(string: videoUrlString) {
                    vc.videoUrl = url
                }
            default:()
                
            }
        }

        vc.stringFormat = stringFormat
        
//        vc.videoUrl = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!
//        vc.stringFormat = .video

        present(vc, animated: true, completion: nil)
    }
}

extension IssueDetailListFileViewController {
    static func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
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
