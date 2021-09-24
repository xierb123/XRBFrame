//
//  ShareImageManager.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

struct ShareImageManager {
    /// 应用图标
    private static let appIcon = UIImage(named: "AppIcon60x60")
    
    /// 获取分享的图片数据
    static func getImageData(image: String, shareType: ShareType, completion: @escaping (Data?) -> Void) {
        let size: CGFloat = (shareType == .weibo) ? 200.0 : 96.0
        let maxKb: Int = (shareType == .weibo) ? 100 : 32
        
        func zipAppIcon(completion: @escaping (Data?) -> Void) {
            if let targetImage = appIcon {
                zipImage(with: targetImage, size: size, maxKb: maxKb) { (data) in
                    completion(data)
                }
            } else {
                completion(nil)
            }
        }

        DispatchQueue.global().async {
            if image.isEmpty {
                zipAppIcon(completion: completion)
            } else {
                if image.contains("http") {
                    ImageManager.retrieveImage(with: image) { (image) in
                        if let targetImage = image ?? appIcon {
                            zipImage(with: targetImage, size: size, maxKb: maxKb, completion: completion)
                        } else {
                            completion(nil)
                        }
                    }
                } else if let locationImage = UIImage(named: image) {
                    zipImage(with: locationImage, size: size, maxKb: maxKb, completion: completion)
                } else {
                    zipAppIcon(completion: completion)
                }
            }
        }
    }
    
    /// 压缩图片到指定大小
    private static func zipImage(with image: UIImage, size: CGFloat, maxKb: Int, completion: @escaping (Data?) -> Void) {
        DispatchQueue.main.async {
            var compressedImage = image.scalingAndCropping(toSize: CGSize(width: size, height: size))
            var data = compressedImage.jpegData(compressionQuality: 1)
            while data != nil && data!.count >= maxKb * 1024 {
                let newData = compressedImage.jpegData(compressionQuality: 0.98)
                if let newData = newData, let newImage = UIImage(data: newData)  {
                    data = newData
                    compressedImage = newImage
                } else {
                    completion(data)
                    return
                }
            }
            completion(data)
        }
    }
}
