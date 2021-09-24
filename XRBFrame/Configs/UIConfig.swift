//
//  UIConfig.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

struct Color {
    static let theme: UIColor = UIColor(hexString: "#FF2954")!
    static let background: UIColor = UIColor.white
    static let navigationItem: UIColor = UIColor(hexString: "#2B2C2E")
    static let mask: UIColor = UIColor.black.withAlphaComponent(0.5)
    static let separator: UIColor = UIColor.white.withAlphaComponent(0.06)
}

struct Layer {
    static func navigationBar() -> CAGradientLayer {
        let frame = CGRect(x: 0.0, y: 0.0, width: Constant.screenWidth, height: Constant.navigationHeight)
        return Layer.default(frame: frame)
    }
        
    static func `default`(frame: CGRect) -> CAGradientLayer {
        let startPoint = CGPoint(x: 1.0, y: 0.03)
        let endPoint = CGPoint(x: 1.0, y: 1.0)
        return custom(frame: frame,
                      startColor: UIColor(hexString: "#46353D"),
                      endColor: UIColor(hexString: "#20263B"),
                      startPoint: startPoint,
                      endPoint: endPoint)
    }
        
    static func custom(frame: CGRect,
                       cornerRadius: CGFloat? = nil,
                       startColor: UIColor? = nil,
                       endColor: UIColor? = nil,
                       startPoint: CGPoint? = nil,
                       endPoint: CGPoint? = nil) -> CAGradientLayer {
        
        let startCGColor = (startColor ?? UIColor(hexString: "#FF3B0F")).cgColor
        let endCGColor = (endColor ?? UIColor(hexString: "#FF542E")).cgColor

        let layer = CAGradientLayer()
        layer.frame = frame
        layer.cornerRadius = cornerRadius ?? 0.0
        layer.colors = [startCGColor, endCGColor]
        layer.locations = [0.0, 1.0]
        layer.startPoint = startPoint ?? CGPoint(x: 1.0, y: 0.5)
        layer.endPoint = endPoint ?? CGPoint(x: 0.5, y: 0.5)
        return layer
    }
}

struct HTML {
    static let customHeader: String = {
        return "<header>"
                + "<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>"
                + "<style>img{max-width:100%;height:auto}</style>"
                + "</header>"
    }()
}
