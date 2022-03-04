//
//  UMMaskedImageView.swift
//  Lulla
//
//  Created by Mac on 2019/11/05.
//  Copyright © 2019 pplus. All rights reserved.
//

import UIKit

// MARK: - UMMaskedImageView

final class UMMaskedImageView: UMImageView {
    
    var maskImage: UIImage? {
        didSet {
            mask = UIImageView(image: maskImage)
            clipsToBounds = true
            contentMode = .scaleAspectFill
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mask?.frame = bounds
    }
    
}
