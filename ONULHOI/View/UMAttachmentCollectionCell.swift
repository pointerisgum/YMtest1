//
//  UMAttachmentCollectionCell.swift
//  AttachmentCollectionM
//
//  Created by Mac on 2018. 7. 17..
//  Copyright © 2018년 Mac. All rights reserved.
//

import UIKit

// MARK: - UMAttachmentCollectionCell

protocol UMAttachmentCollectionCellDelegate: class {
	func attachmentCollectionCell(_ cell: UMAttachmentCollectionCell, didAction action: UMAttachmentCollectionCell.Action)
}

final class UMAttachmentCollectionCell: UICollectionViewCell {
	
	enum Action { case play }
	
	weak var delegate: UMAttachmentCollectionCellDelegate?
	
	@IBOutlet weak var lcPlayCenterY: NSLayoutConstraint!
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var overlayView: UIView!
	@IBOutlet weak var playButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
	}
	
	@IBAction func onPlay(_ sender: UIButton) {
		delegate?.attachmentCollectionCell(self, didAction: .play)
	}
    
}
