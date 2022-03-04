//
//  UITextView+M.swift
//  Dada
//
//  Created by 김영민 on 2021/07/03.
//

import UIKit

extension UITextView {
    public func textRangeFromNSRange(range:NSRange) -> UITextRange? {
        let beginning = self.beginningOfDocument
        guard let start = self.position(from: beginning, offset: range.location), let end = self.position(from: start, offset: range.length) else { return nil}
        return self.textRange(from: start, to: end)
    }
}
