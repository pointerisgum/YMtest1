//
//  UMAttachmentInsertView.swift
//  PPBiz
//
//  Created by Mac on 2018. 7. 17..
//  Copyright © 2018년 Mac. All rights reserved.
//

import UIKit

// MARK: - UMAttachmentInsertView

extension UMAttachmentInsertView {
	
	class Item {
		
		var image: UIImage?
		
		init(image: UIImage?) {
			self.image = image
		}
		
	}
	
}

final class UMAttachmentInsertView: UXibView {
	
	var items: [Item] = [] {
		didSet {
			
			addButton.isHidden = (items.count > 0)
			collectionView.reloadData()
			collectionView.contentOffset = .zero
		}
	}
	
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var addButton: UIButton!

	override func awakeFromNib() {
		super.awakeFromNib()
		
		if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			layout.scrollDirection = .horizontal
		}
		collectionView.showsVerticalScrollIndicator = false
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.isPagingEnabled = true
		collectionView.dataSource = self
		collectionView.delegate = self
		
		collectionView.register(type: UMAttachmentInsertCell.self)
	}
	
}

// MARK: - UICollectionViewDataSource

extension UMAttachmentInsertView: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let item = items[indexPath.item]
		
		let cell: UMAttachmentInsertCell = collectionView.dequeueReusableCell(for: indexPath)
		cell.imageView.image = item.image
		
		return cell
	}
	
}

// MARK - UICollectionViewDelegateFlowLayout

extension UMAttachmentInsertView: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return collectionView.frame.size
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return .zero
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return .zero
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return .zero
	}
	
}

// MARK: - UICollectionViewDelegate

extension UMAttachmentInsertView: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
	}
	
}
