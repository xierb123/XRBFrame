//
//  ShareCell.swift
//  HiconMultiScreen
//
//  Created by devchena on 2020/11/26.
//

import UIKit

class ShareCell: UICollectionViewCell {
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView()
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(snp.width)
        }
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        titleLabel.font = UIFont.systemFont(ofSize: 10.0)
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(type: ShareType) {
        switch type {
        case .wxSceneSession:
            imageView.image = UIImage(named: "ic_share_wechat_scenesession")
            titleLabel.text = "微信"
        case .wxSceneTimeline:
            imageView.image = UIImage(named: "ic_share_wechat_timeline")
            titleLabel.text = "朋友圈"
        case .qqFriends:
            imageView.image = UIImage(named: "ic_share_qq")
            titleLabel.text = "QQ"
        case .weibo:
            imageView.image = UIImage(named: "ic_share_weibo")
            titleLabel.text = "微博"
        case .copy:
            imageView.image = UIImage(named: "ic_share_copy")
            titleLabel.text = "复制链接"
        case .report:
            imageView.image = UIImage(named: "ic_share_report")
            titleLabel.text = "举报"
        }
    }
}
