//
//  BannerPagerCell.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/11/4.
//

import UIKit
import FSPagerView

class BannerPagerCell: FSPagerViewCell {
    //MARK: - 标识符
    static let identifier = "BannerPagerCell"
    
    
    //MARK: - 全局变量
    private var bgImageView: UIImageView!
    private var frontImageView: UIImageView!
    private var titleLabel: UILabel!
    private var index: Int?
    
    //MARK: - 懒加载
    
    //MARK: - init/deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI布局
    private func setupView() {
        // 设置UI
        setupBGImageView()
        setupFrontImageView()
        setupTitleLabel()
        layoutIfNeeded()
    }
    
    private func setupBGImageView() {
        bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "ic_address_empty")
        bgImageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            // 自动布局
            make.edges.equalToSuperview()
        }
    }
    
    private func setupFrontImageView() {
        frontImageView = UIImageView()
        frontImageView.image = UIImage(named: "ic_address_empty")
        frontImageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(frontImageView)
        frontImageView.snp.makeConstraints { (make) in
            // 自动布局
            make.left.equalTo(Constant.screenWidth)
            make.centerY.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.5)
        }
        frontImageView.isHidden = true
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.textColor = .red
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            // 自动布局
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

//MARK: - 选择器事件(自定义方法)
extension BannerPagerCell {
    /// 数据填充
    func show(index: Int) {
        
        self.index = index
        titleLabel.text = "\(index)"
    }
    
    func startAnimation() {
        frontImageView.isHidden = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else {return}
            self.frontImageView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalToSuperview().multipliedBy(0.5)
            }
            self.layoutIfNeeded()
        }
    }
    func endAnimation() {
        frontImageView.isHidden = false
        self.frontImageView.snp.remakeConstraints { make in
            make.left.equalTo(Constant.screenWidth)
            make.centerY.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.5)
        }
    }
}


