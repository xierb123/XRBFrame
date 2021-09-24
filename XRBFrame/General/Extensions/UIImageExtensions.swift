//
//  UIImageExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

// MARK: - Initializers
extension UIImage {
    /// Create UIImage from color and size.
    ///
    /// - Parameters:
    ///   - color: image fill color.
    ///   - size: image size.
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        
        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }
        
        self.init(cgImage: aCgImage)
    }
}

// MARK: - Properties
extension UIImage {
    /// Returns gray image.
    var gray: UIImage {
        let image = self
        guard let imageRef: CGImage = image.cgImage else {
            return image
        }
        
        let width: Int = imageRef.width
        let height: Int = imageRef.height
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        //        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        guard let context: CGContext = CGContext(data: nil,
                                                 width: width,
                                                 height: height,
                                                 bitsPerComponent: 8,
                                                 bytesPerRow: 0,
                                                 space: colorSpace,
                                                 bitmapInfo: bitmapInfo.rawValue) else {
            return image
        }
        
        let rect: CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        context.draw(imageRef, in: rect)
        guard let outPutImage: CGImage = context.makeImage() else {
            return image
        }
        
        let grayImage: UIImage = UIImage(cgImage: outPutImage,
                                         scale: self.scale,
                                         orientation: self.imageOrientation)
        return grayImage
    }
}

// MARK: - Methods
extension UIImage {
    /// UIImage filled with color
    ///
    /// - Parameter color: color to fill image with.
    /// - Returns: UIImage filled with given color.
    func filled(withColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = cgImage else { return self }
        context.clip(to: rect, mask: mask)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// UIImage tinted with color
    ///
    /// - Parameters:
    ///   - color: color to tint image with.
    ///   - blendMode: how to blend the tint
    /// - Returns: UIImage tinted with given color.
    func tint(withColor color: UIColor, blendMode: CGBlendMode) -> UIImage {
        let drawRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        context!.clip(to: drawRect, mask: cgImage!)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}

extension UIImage {
    /// Compressed UIImage from original UIImage.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
    /// - Returns: optional UIImage (if applicable).
    func compressed(quality: CGFloat = 0.5) -> UIImage? {
        guard let data = compressedData(quality: quality) else { return nil }
        return UIImage(data: data)
    }
    
    /// Compressed UIImage data from original UIImage.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
    /// - Returns: optional Data (if applicable).
    func compressedData(quality: CGFloat = 0.5) -> Data? {
        return jpegData(compressionQuality: quality)
    }
    
    /// UIImage Cropped to CGRect.
    ///
    /// - Parameter rect: CGRect to crop UIImage to.
    /// - Returns: cropped UIImage
    func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.width < size.width && rect.size.height < size.height else { return self }
        guard let image: CGImage = cgImage?.cropping(to: rect) else { return self }
        return UIImage(cgImage: image)
    }
    
    /// Resize image
    func resized(toSize size: CGSize) -> UIImage {
        guard size.width > 0 && size.height > 0  else {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    /// Uniform scaling
    func scaled(_ scale: CGFloat) -> UIImage {
        guard scale > 0  else {
            return self
        }
        let size = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        return resized(toSize: size)
    }
    
    /// UIImage scaled to height with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toHeight: new height.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toHeight / size.height
        let newWidth = size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, 0)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// UIImage scaled to width with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toWidth: new width.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, 0)
        draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Creates a copy of the receiver rotated by the given angle.
    ///
    ///     // Rotate the image by 180°
    ///     image.rotated(by: Measurement(value: 180, unit: .degrees))
    ///
    /// - Parameter angle: The angle measurement by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    @available(iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    func rotated(by angle: Measurement<UnitAngle>) -> UIImage? {
        let radians = CGFloat(angle.converted(to: .radians).value)
        
        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())
        
        UIGraphicsBeginImageContext(roundedDestRect.size)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }
        
        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)
        
        draw(in: CGRect(origin: CGPoint(x: -size.width / 2,
                                        y: -size.height / 2),
                        size: size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Creates a copy of the receiver rotated by the given angle (in radians).
    ///
    ///     // Rotate the image by 180°
    ///     image.rotated(by: .pi)
    ///
    /// - Parameter radians: The angle, in radians, by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    func rotated(by radians: CGFloat) -> UIImage? {
        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())
        
        UIGraphicsBeginImageContext(roundedDestRect.size)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }
        
        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)
        
        draw(in: CGRect(origin: CGPoint(x: -size.width / 2,
                                        y: -size.height / 2),
                        size: size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// UIImage with rounded corners
    ///
    /// - Parameters:
    ///   - radius: corner radius (optional), resulting image will be round if unspecified
    /// - Returns: UIImage with all corners rounded
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    /// Fix orientation
    func fixOrientation() -> UIImage {
        guard self.imageOrientation != .up else {
            return self
        }
        
        var transform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi/2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -CGFloat.pi/2)
        default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        guard let cgImage = self.cgImage else {
            return self
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let context = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: Int(cgImage.bitsPerComponent), bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return self
        }
        context.concatenate(transform)
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
        default:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        }
        
        if let cgImg = context.makeImage() {
            return UIImage(cgImage: cgImg)
        }
        
        return self
    }
    
    /// 压缩图片
    ///
    /// - Parameters:
    ///   - size: 目标图片尺寸
    /// - Returns: 压缩后的图片或原图
    func scalingAndCropping(toSize targetSize: CGSize) -> UIImage {
        // 压缩后的图片
        var newImage: UIImage?
        
        // 原图片大小
        let imageSize = self.size
        // 原图片宽度
        let width = imageSize.width
        // 原图片高度
        let height = imageSize.height
        
        // 压缩宽度
        let targetWidth = targetSize.width
        // 压缩高度
        let targetHeight = targetSize.height
        // 压缩比例系数（默认为0）
        var scaleFactor: CGFloat = 0.0
        
        // 图片的宽度和高度小于要压缩的宽度和高度，不需要压缩
        if width <= targetWidth && height <= targetHeight {
            return self
        }
        // 图片的宽度和高度都等于0，不需要压缩
        if width == 0 || height == 0 {
            return self
        }
        
        // 宽度比例
        var scaledWidth = targetWidth
        // 高度比例
        var scaledHeight = targetHeight
        // 压缩点
        var thumbnailPoint = CGPoint.zero
        
        // 如果原图片大小跟要压缩大小相同，则不执行压缩动作，否则执行压缩动作，执行：
        if imageSize != targetSize && (width > 0 && height > 0) {
            // 宽度系数，格式：50／100＝0.5
            let widthFactor = targetWidth / width
            // 高度系数，格式：50／100＝0.5
            let heightFactor = targetHeight / height
            
            if widthFactor > heightFactor {
                scaleFactor = widthFactor // scale to fit height
            } else {
                scaleFactor = heightFactor // scale to fit width
            }
            
            // 压缩后的宽度＝原宽度＊宽度压缩系数
            scaledWidth = width * scaleFactor
            // 压缩后的高度＝原高度＊高度压缩系数
            scaledHeight = height * scaleFactor
            
            // center the image
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            } else if (widthFactor < heightFactor) {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        
        // 以下执行压缩动作
        UIGraphicsBeginImageContext(CGSize(width: Int(targetSize.width),
                                           height: Int(targetSize.height)))
        
        var thumbnailRect: CGRect = .zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size = CGSize(width: Int(scaledWidth),
                                    height: Int(scaledHeight))
        
        draw(in: thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
}

extension UIImage {
    /// 图片高斯模糊
    ///
    /// - Parameters:
    ///   - radius: 模糊半径
    ///   - rect: 高斯模糊区域
    /// - Returns: 处理后的图片
    func gaussianBlur(withRadius radius: CGFloat = 6.0, from rect: CGRect? = nil) -> UIImage? {
        // 使用高斯模糊滤镜
        guard let filter = CIFilter(name: "CIGaussianBlur") else {
            return nil
        }
        let inputImage = CIImage(image: self)
        filter.setValue(inputImage, forKey:kCIInputImageKey)
        // 设置模糊半径值（越大越模糊）
        filter.setValue(radius, forKey: kCIInputRadiusKey)
        
        guard let outputCIImage = filter.outputImage else {
            return nil
        }
        let context = CIContext()
        let area = rect ?? CGRect(origin: .zero, size: size)
        guard let cgImage = context.createCGImage(outputCIImage, from: area) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
    
    /// 图片拉伸（只拉伸左右，保护中间）
    func stretchLeftAndRight(containerSize: CGSize) -> UIImage? {
        let imageSize = size
        
        // 第一次拉伸右边，保护左边
        let image = stretchableImage(withLeftCapWidth: Int(imageSize.width * 0.8),
                                     topCapHeight: Int(imageSize.height))
        
        // 第一次拉伸的距离之后图片总宽度
        let tempWidth: CGFloat = containerSize.width / 2.0 + imageSize.width / 2.0
        let size = CGSize(width: tempWidth, height: imageSize.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        image.draw(in: CGRect(x: 0.0, y: 0.0, width: tempWidth, height: containerSize.height))
        
        // 拉伸过的图片
        let firstStrechedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let strechedImage = firstStrechedImage else {
            return nil
        }
        // 第二次拉伸左边，保护右边
        let secondStrechedImage = strechedImage.stretchableImage(withLeftCapWidth: Int(imageSize.width * 0.2),
                                                                 topCapHeight: Int(imageSize.height))
        
        return secondStrechedImage
    }
}

extension UIImage {
    func compressImageMid(maxLength: Int) -> Data? {
        var compression: CGFloat = 1
        guard var data = self.jpegData(compressionQuality: 1) else { return nil }
        if data.count < maxLength {
            return data
        }
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = self.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        var _: UIImage = UIImage(data: data)!
        if data.count < maxLength {
            return data
        }
        return nil
    }
}

extension UIImage {
    /// 切割图片
    func clip(_ rect: CGRect) -> UIImage {
        if let cgImage = cgImage?.cropping(to: rect) {
            return UIImage(cgImage: cgImage)
        }
        return self
    }
}
