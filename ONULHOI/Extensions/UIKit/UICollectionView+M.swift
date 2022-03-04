//
//  UICollectionView+M.swift
//  Lulla
//
//  Created by Mac on 2018. 4. 17..
//  Copyright © 2018년 pplus. All rights reserved.
//

import UIKit

extension UICollectionView {
	
	func m_reloadData() {
		reloadData()
		//collectionViewLayout.invalidateLayout()
	}

    func scrollToBottom(animation: Bool = false){
        DispatchQueue.main.async {
            let lastSectionIndex = max(0, self.numberOfSections - 1)
            let lastRowIndex = max(0, self.numberOfItems(inSection: lastSectionIndex) - 1)
            let indexPath = IndexPath(row: lastRowIndex, section: lastSectionIndex)
            self.scrollToItem(at: indexPath, at: .bottom, animated: animation)
        }
    }

    func scrollToTop(animation: Bool = false) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToItem(at: indexPath, at: .top, animated: animation)
        }
    }

}
