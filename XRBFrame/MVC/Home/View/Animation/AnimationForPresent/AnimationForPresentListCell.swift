//
//  AnimationForPresentListCell.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/28.
//
//  present转场动画的列表视图

import UIKit

class AnimationForPresentListCell: UICollectionViewCell {
    //MARK: - 标识符
    static let identifier = "AnimationForPresentListCell"
    
    
    //MARK: - 全局变量
    private var imageView: UIImageView!
    private var timeLabel: UILabel!
    private var noticeLabel: UILabel!
    private var userImageView: UIImageView!
    private var userNameLabel: UILabel!
    private var model: AnimationForPresentListEntity!
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
        self.contentView.backgroundColor = .white
        self.layer.borderColor = UIColor.purple.cgColor
        self.layer.borderWidth = 2
        self.setCornerRadius(4, masksToBounds: true)
        
        setupImageView()
        setupTimeLabel()
        setupNoticeLabel()
        setupUserImageView()
        setupUserNameLabel()
    }
    
    /// 设置背景图片
    private func setupImageView() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            // 自动布局
            make.left.top.right.equalToSuperview()
            make.height.equalTo(self.width*1.2)
        }
    }
    /// 设置时长标签
    private func setupTimeLabel() {
        timeLabel = UILabel()
        timeLabel.textAlignment = .left
        timeLabel.textColor = .red
        timeLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        self.imageView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            // 自动布局
            make.right.bottom.equalTo(-Constant.margin)
        }
    }
    
    /// 设置标题标签
    private func setupNoticeLabel() {
        noticeLabel = UILabel()
        noticeLabel.textAlignment = .left
        noticeLabel.textColor = .darkGray
        noticeLabel.numberOfLines = 2
        noticeLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.contentView.addSubview(noticeLabel)
        noticeLabel.snp.makeConstraints { (make) in
            // 自动布局
            make.top.equalTo(imageView.snp.bottom)
            make.left.equalTo(Constant.margin*1.4)
            make.right.equalTo(-Constant.margin*1.4)
        }
    }
    
    /// 设置用户头像图片
    private func setupUserImageView() {
        userImageView = UIImageView()
        userImageView.contentMode = .scaleAspectFit
        userImageView.setCornerRadius(10)
        self.contentView.addSubview(userImageView)
        userImageView.snp.makeConstraints { (make) in
            // 自动布局
            make.left.equalTo(noticeLabel)
            make.bottom.equalTo(-Constant.margin)
            make.width.height.equalTo(20)
        }
    }
    
    /// 设置用户名标签
    private func setupUserNameLabel() {
        userNameLabel = UILabel()
        userNameLabel.textAlignment = .left
        userNameLabel.textColor = .darkGray
        userNameLabel.numberOfLines = 2
        userNameLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.contentView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { (make) in
            // 自动布局
            make.left.equalTo(userImageView.snp.right).offset(Constant.margin)
            make.centerY.equalTo(userImageView)
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension AnimationForPresentListCell: BindData {
    func bindData(_ data: Any?) {
        if let viewModel = data as? AnimationForPresentListEntity {
            
            self.model = viewModel
            self.imageView.image = UIImage(named: viewModel.imageName)
            self.timeLabel.text = viewModel.time
            self.noticeLabel.setText(viewModel.title, lineSpacing: 4.0)
            self.userImageView.image = UIImage(named: viewModel.userImage)
            self.userNameLabel.text = viewModel.userName
        }
    }
}

