//
//  UIButtonExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

enum ImageAlignment {
    case center       //设置图片居中, 用于setImageSize()
    case top          //图片在上，文字在下，垂直居中对齐
    case bottom       //图片在下，文字在上，垂直居中对齐
    case left         //图片在左，文字在右，水平居中对齐
    case right        //图片在右，文字在左，水平居中对齐
}

fileprivate var rectNameKey:(Character?,Character?,Character?,Character?)

// MARK: - Methods
extension UIButton {
    func setImageSize(_ size: CGSize, alignment: ImageAlignment) {
        let top: CGFloat = (frame.height - size.height) / 2.0
        let bottom: CGFloat = top
        var left: CGFloat = 0.0
        var right: CGFloat = 0.0
        
        switch alignment {
        case .center:
            left = (frame.width - size.width) / 2.0
            right = left
        case .left:
            left = 0.0
            right = frame.width - size.width
        case .right:
            left = frame.width - size.width
            right = 0.0
        default:
            break
        }
        
        imageEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    /// - Description 设置Button图片的位置
    /// - Parameters:
    ///   - style: 图片位置
    ///   - spacing: 按钮图片与文字之间的间隔
    func imagePosition(style: ImageAlignment, spacing: CGFloat) {
        //得到imageView和titleLabel的宽高
        let imageWidth = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        
        var labelWidth: CGFloat! = 0.0
        var labelHeight: CGFloat! = 0.0
        
        labelWidth = self.titleLabel?.intrinsicContentSize.width
        labelHeight = self.titleLabel?.intrinsicContentSize.height
        
        //初始化imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .top:
            //上 左 下 右
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-spacing/2, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!, bottom: -imageHeight!-spacing/2, right: 0)
            break;
            
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
            break;
            
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight!-spacing/2, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight!-spacing/2, left: -imageWidth!, bottom: 0, right: 0)
            break;
            
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+spacing/2, bottom: 0, right: -labelWidth-spacing/2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!-spacing/2, bottom: 0, right: imageWidth!+spacing/2)
            break;
        default :
            break
        }
        
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
}

extension UIButton {
    
    
    private struct AssociatedKey {
        static var largeEdge: CGFloat = 0
    }
    
    public var largeEdge: CGFloat {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.largeEdge) as? CGFloat ?? 0.0
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey.largeEdge, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let zqmargin:CGFloat = -largeEdge
        let clickArea = bounds.insetBy(dx: zqmargin, dy: zqmargin)
        return clickArea.contains(point)
    }
}
