//
//  UITableView+M.swift
//  Lulla
//
//  Created by Mac on 2019/11/07.
//  Copyright © 2019 pplus. All rights reserved.
//

import UIKit

extension UITableView {
    
    func automaticHeaderSize() {
        guard let view = tableHeaderView else { return }
        
        let size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        if view.frame.size.height != size.height {
            view.frame.size.height = size.height
            tableHeaderView = view
            layoutIfNeeded()
        }
    }
    
    func automaticFooterSize() {
        guard let view = tableFooterView else { return }
        
        let size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        if view.frame.size.height != size.height {
            view.frame.size.height = size.height
            tableFooterView = view
            layoutIfNeeded()
        }
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    func scrollToTop(withAnimation: Bool = false) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: withAnimation)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
