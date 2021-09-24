//
//  ExampleIrregularityContentView.swift
//  HiconTV
//
//  Created by devchena on 2020/2/24.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class TabBarItemIrregularityContentView: ESTabBarItemContentView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.size = CGSize(width: 48, height: 48)
        insets = UIEdgeInsets(top: -12, left: 0, bottom: 0, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        superview?.bringSubviewToFront(self)
    }
}
