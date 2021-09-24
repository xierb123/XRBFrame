//
//  IntegralMallTabBarItemContentView.swift
//  HiconTV
//
//  Created by devchena on 2020/5/9.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import Lottie
import ESTabBarController_swift

class IntegralMallTabBarItemContentView: ESTabBarItemContentView {
    private var selectedAnimationView: AnimationView!
    private var normalAnimationView: AnimationView!

    override init(frame: CGRect) {
        super.init(frame: frame)
                
        selectedAnimationView = AnimationView(name: "tab_mall_selected")
        selectedAnimationView.contentMode = .scaleAspectFill
        selectedAnimationView.animationSpeed = 1.5
        addSubview(selectedAnimationView)

        selectedAnimationView.snp.makeConstraints { (make) in
            make.top.equalTo(-24)
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(72)
        }

        normalAnimationView = AnimationView(name: "tab_mall_normal")
        normalAnimationView.contentMode = .scaleAspectFill
        normalAnimationView.animationSpeed = 2.0
        addSubview(normalAnimationView)

        normalAnimationView.snp.makeConstraints { (make) in
            make.edges.equalTo(selectedAnimationView)
        }
        
        textColor = UIColor(hexString: "#666666")
        highlightTextColor = Color.theme
        titleLabel.font = UIFont.systemFont(ofSize: 11.0)
        bringSubviewToFront(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(12)
        }

        DispatchQueue.main.async {
            self.deselectAnimation(animated: true, completion: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.isHidden = true
    }

    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        normalAnimationView.isHidden = true
        normalAnimationView.stop()
        selectedAnimationView.isHidden = false
        selectedAnimationView.play()
        completion?()
    }
    
    override func deselectAnimation(animated: Bool, completion: (() -> ())?) {
        selectedAnimationView.isHidden = true
        selectedAnimationView.stop()
        normalAnimationView.isHidden = false
        normalAnimationView.play()
        completion?()
    }
}
