//
//  UIImageViewExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import Kingfisher

// MARK: - Methods
extension UIImageView {
    /// Set an image with a url, a placeholder image.
    func setImage(with url: String?,
                  placeholder: UIImage? = nil,
                  forceRefresh: Bool = false,
                  completionHandler: ((UIImage?) -> Void)? = nil) {
        
        var imageURL: URL?
        if let string = url, !string.isEmpty {
            if string.isValidHttpURL || string.isValidHttpsURL {
                imageURL = URL(string: string)
            } else {
                imageURL = AppConfig.imageBaseURL.appendingPathComponent(string)
            }
        }
        
        var options: KingfisherOptionsInfo = []
        if forceRefresh {
            options.append(.forceRefresh)
        }
        
        kf.setImage(with: imageURL, placeholder: placeholder, options: options) { result in
            switch result {
            case .success(let value):
                completionHandler?(value.image)
            case .failure:
                completionHandler?(nil)
            }
        }
    }
}

extension UIImageView {
    /// 360度旋转图片
    func rotate360Degree() {
        rotate(to: Double.pi * 2.0, duration: 0.6, repeatCount: 100000)
    }
    
    /// 旋转
    func rotate(to value: Double, duration: TimeInterval, repeatCount: CGFloat = 1.0) {
        // 让其在z轴旋转
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        // 旋转角度
        rotationAnimation.toValue = NSNumber(value: value)
        // 旋转周期
        rotationAnimation.duration = duration
        // 旋转累加角度
        rotationAnimation.isCumulative = true // 旋转累加角度
        // 上限旋转次数
        rotationAnimation.repeatCount = Float(repeatCount)
        layer.add(rotationAnimation, forKey: "rotationAnimation")
    }

    /// 停止旋转
    func stopRotate() {
        layer.removeAllAnimations()
    }
}
