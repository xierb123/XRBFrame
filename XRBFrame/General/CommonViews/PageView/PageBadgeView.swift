//
//  PageBadgeView.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

class PageBadgeView: UIView {
    var badgeColor: UIColor? {
        didSet {
            imageView.backgroundColor = badgeColor
        }
    }
    
    var badgeValue: String? {
        didSet {
            badgeLabel.text = badgeValue
        }
    }
        
    var badgeLabel: UILabel = {
        let badgeLabel = UILabel(frame: .zero)
        badgeLabel.textColor = .white
        badgeLabel.font = UIFont.systemFont(ofSize: 9.0)
        badgeLabel.textAlignment = .center
        return badgeLabel
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView(frame:.zero)
        return imageView
    }()
    
    private static let defaultBadgeColor = UIColor(red: 255.0/255.0, green: 41.0/255.0, blue: 84.0/255.0, alpha: 1.0)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(badgeLabel)
        imageView.backgroundColor = badgeColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let value = badgeValue, !value.isEmpty else {
            imageView.isHidden = true
            badgeLabel.isHidden = true
            return
        }
        
        imageView.isHidden = false
        badgeLabel.isHidden = false
        
        imageView.frame = bounds
        imageView.layer.cornerRadius = imageView.bounds.size.height / 2.0
        badgeLabel.sizeToFit()
        badgeLabel.center = imageView.center
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let _ = badgeValue else {
            return CGSize(width: 16.0, height: 16.0)
        }
        let textSize = badgeLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: max(16.0, textSize.width + 6.0), height: 16.0)
    }
 }
