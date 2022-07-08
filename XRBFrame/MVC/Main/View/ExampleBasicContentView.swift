//
//  ExampleBasicContentView.swift
//  ESTabBarControllerExample
//
//  Created by lihao on 2017/2/9.
//  Copyright © 2018年 Egg Swift. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class ExampleBasicContentView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = UIColor(hexString: "#666666")!
        highlightTextColor = Color.theme
        titleLabel.font = UIFont.systemFont(ofSize: 11.0)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(37)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(12)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
