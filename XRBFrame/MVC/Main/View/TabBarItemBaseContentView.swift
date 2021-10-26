//
//  TabBarItemBaseContentView.swift
//  HiconTV
//
//  Created by devchena on 2020/3/4.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class TabBarItemBaseContentView: ESTabBarItemContentView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = UIColor(hexString: "#666666")
        highlightTextColor = Color.theme
        titleLabel.font = UIFont.systemFont(ofSize: 11.0)
        
        //FIXME: - 修改icon的布局
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(Constant.margin/2)
            make.width.height.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(12)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
