//
//  UMImageStatusView.swift
//  Lulla
//
//  Created by 김상선 on 2020/05/18.
//  Copyright © 2020 pplus. All rights reserved.
//

import UIKit

// MARK: - UMImageStatusView

final class UMImageStatusView: UMView {
    
    class func statusView(inView: UIView, image: UIImage, text: String) -> UMImageStatusView {
        let frame: CGRect = {
            switch inView {
            case let scrollView as UIScrollView:
                var frame = inView.bounds
                frame.size.height -= (scrollView.contentInset.top + scrollView.contentInset.bottom)
                return frame
            default:
                return inView.bounds
            }
        }()
        
        let statusView = UMImageStatusView(frame: frame)
        statusView.backgroundColor = .clear
        
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = image
        
        let textLabel = UILabel(frame: statusView.bounds.insetBy(dx: 22, dy: 0))
        textLabel.backgroundColor = .clear
        textLabel.textColor = UIColor(hex: 0x737373)
        textLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.text = text
        
        statusView.stackView.translatesAutoresizingMaskIntoConstraints = false
        statusView.stackView.addArrangedSubviews([imageView, textLabel])
        
        NSLayoutConstraint.activate([
            statusView.stackView.centerXAnchor.constraint(equalTo: statusView.centerXAnchor, constant: 0),
            statusView.stackView.centerYAnchor.constraint(equalTo: statusView.centerYAnchor, constant: 0)
        ])
        
        return statusView
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        addSubview(stackView)
        
        return stackView
    }()
    
}

