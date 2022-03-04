//
//  UXibView.swift
//  Lulla
//
//  Created by Mac on 2018. 1. 15..
//  Copyright © 2018년 pplus. All rights reserved.
//

import UIKit

class UXibView: UIView {
    
    var rootView : UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        rootView = loadViewFromNib()
        rootView!.backgroundColor = .clear
        rootView!.frame = bounds
        rootView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(rootView!)
    }
    
    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: self.classForCoder)
        let nib = UINib(nibName: String(describing: self.classForCoder), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
}

