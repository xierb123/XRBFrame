//
//  BannerViewCell.swift
//  BannerDemo
//
//  Created by ༺ོ࿆强ོ࿆ ༻ on 2020/4/24.
//  Copyright © 2020 ༺ོ࿆强ོ࿆ ༻. All rights reserved.
//

import UIKit

class BannerViewCell: UICollectionViewCell {
    /// 模型对象
    public var infoModel:BannerBaseDataInfo? {
        willSet {
            guard let dataInfo = newValue else {
                return
            }
            switch dataInfo.type {
            case .bannerImageInfoTypeLocality:
               self.loadImageView?.image = dataInfo.image ?? self.placeholderImage
                break
            case .bannerImageInfoTypeGIFImage:
                self.loadImageView?.image = self.placeholderImage
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                     self.loadImageView?.image = dataInfo.image ?? self.placeholderImage
                }
                break
            default:
//                self.loadImageView?.setImageWithURL(dataInfo.imageUrl, self.placeholderImage)
                self.loadImageView?.setImage(with: dataInfo.imageUrl,placeholder:self.placeholderImage)
//                self.loadImageView?.setimage
                self.animationImageView?.setImage(with: dataInfo.animationUrl)
            }
        }
    }
    /// 图片显示方式
    public var imageContentMode:UIView.ContentMode = .scaleToFill {
        willSet {
            self.loadImageView?.contentMode = newValue
        }
    }
    /// 圆角
    public var imgCornerRadius:CGFloat = 0.0 {
        willSet {
            if newValue > 0.0 {
                let maskPath = UIBezierPath(roundedRect: (self.loadImageView?.bounds ?? CGRect.zero), cornerRadius: newValue)
                let maskLayer = CAShapeLayer()
                maskLayer.frame = self.bounds
                maskLayer.path = maskPath.cgPath
                self.loadImageView?.layer.mask = maskLayer
            }
        }
    }
    
    
    func playAnimation()  {
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveLinear) {
            self.animationImageView?.x = 0
        } completion: { (finish) in
            
        }

    }
    
    func AnimationEnd()  {
        self.animationImageView?.x = 0
    }
    
    func AnimationStart()  {
        self.animationImageView?.x = contentView.width
    }
    
    /// 占位图
    public var placeholderImage:UIImage?
    /// 是否裁剪，默认false
    public var isClips = false {
        willSet {
             self.loadImageView?.isClips = newValue
        }
    }
    
    private var loadImageView:LoadImageView?
    private var animationImageView:LoadImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        setupImageView()
        setupAnimationImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupImageView() {
        let loadImageView = LoadImageView(frame: CGRect(x: self.bounds.origin.x, y: 20, width: self.bounds.size.width, height: self.bounds.size.height - 20))
        loadImageView.contentMode = self.contentMode
        loadImageView.isClips = self.isClips
        loadImageView.image = placeholderImage
        loadImageView.layer.contentsGravity = .resizeAspectFill
        loadImageView.clipsToBounds = true
        self.contentView.addSubview(loadImageView)
        self.loadImageView = loadImageView

//        self.contentView.addSubview(imageV)
    }
    
    private func setupAnimationImageView() {
        let loadImageView = LoadImageView(frame: self.bounds)
        loadImageView.contentMode = .scaleToFill
//        loadImageView.isClips = self.isClips
//        loadImageView.image = placeholderImage
        loadImageView.backgroundColor = .clear
//        loadImageView.layer.contentsGravity = .resizeAspectFill
        loadImageView.clipsToBounds = true
        self.contentView.addSubview(loadImageView)
        self.animationImageView = loadImageView
//        self.animationImageView?.x = contentView.width
//        self.contentView.addSubview(imageV)
    }
//无用
    public lazy var imageV:UIImageView = {
        let imgV = UIImageView()
        imgV.frame = CGRect(x: 0, y: -3, width: kScreenWidth - 48, height: 160)
        imgV.backgroundColor = .red
        imgV.alpha = 0.5
        return imgV
    }()
    
}
