//
//  NavigationBar.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

protocol CustomNavigationBarDelegate: AnyObject {
    func goback(_ navigationBar: CustomNavigationBar)
}

class CustomNavigationBar: UIView {
    weak var delegate: CustomNavigationBarDelegate?

    var title: String? {
        set {
            titleLabel.text = newValue
        }
        get {
            return titleLabel.text
        }
    }
    
    var titleColor: UIColor = UIColor(hexString: "#FFFFFF") {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    var backImage: UIImage? = UIImage(named: "ic_navigation_back") {
        didSet {
            backBtn.setImage(backImage, for: .normal)
        }
    }

    var backgroundImage: UIImage? {
        set {
            backgroundImageView.image = newValue
        }
        get {
            return backgroundImageView.image
        }
    }

    var isBackHidden: Bool = false {
        didSet {
            backBtn.isHidden = isBackHidden
        }
    }
    
    var separatorColor: UIColor = UIColor(hexString: "#F6F6F6") {
        didSet {
            separator.backgroundColor = separatorColor
        }
    }

    var isSeparatorHidden: Bool = true {
        didSet {
            separator.isHidden = isSeparatorHidden
        }
    }

    private var backgroundImageView: UIImageView!
    private var titleLabel: UILabel!
    private var backBtn: UIButton!
    private var separator: UIView!

    init() {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: Constant.screenWidth, height: Constant.navigationHeight))
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = Color.navigationItem

        backgroundImageView = UIImageView()
        addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        backBtn = UIButton()
        backBtn.setImage(backImage, for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)
        backBtn.isHidden = isBackHidden
        addSubview(backBtn)
        
        backBtn.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalTo(Constant.statusBarHeight + Constant.navigationBarHeight / 2.0)
            make.width.height.equalTo(24)
        }

        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = titleColor
        titleLabel.font = UIFont.systemFont(ofSize: 18.0)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(56)
            make.right.equalTo(-56)
            make.centerY.equalTo(backBtn)
        }

        separator = UIView()
        separator.backgroundColor = separatorColor
        separator.isHidden = isSeparatorHidden
        addSubview(separator)
        
        separator.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1.0 / UIScreen.main.scale)
        }
    }
}

extension CustomNavigationBar {
    @objc private func backBtnClicked() {
        delegate?.goback(self)
    }
}
