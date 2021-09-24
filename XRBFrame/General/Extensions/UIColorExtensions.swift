//
//  UIColorExtensions
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

// MARK: - Initializers
extension UIColor {
    /// Init method with RGB values from 0 to 255, instead of 0 to 1. With alpha(default:1).
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }

    /// Init method with hex string and alpha(default: 1).
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
          let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
          let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
          let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
          self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return nil
        }
    }

    /// Init method from Gray value and alpha(default:1).
    convenience init(gray: CGFloat, alpha: CGFloat = 1) {
        self.init(red: gray/255, green: gray/255, blue: gray/255, alpha: alpha)
    }
}

// MARK: - Properties
extension UIColor {
    /// Random color.
    static var random: UIColor {
        let r: CGFloat = CGFloat(drand48())
        let g: CGFloat = CGFloat(drand48())
        let b: CGFloat = CGFloat(drand48())
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }

    /// Red component of UIColor (get-only).
    var redComponent: Int {
        var r: CGFloat = 0
        getRed(&r, green: nil, blue: nil, alpha: nil)
        return Int(r * 255)
    }

    /// Green component of UIColor (get-only).
    var greenComponent: Int {
        var g: CGFloat = 0
        getRed(nil, green: &g, blue: nil, alpha: nil)
        return Int(g * 255)
    }

    /// Blue component of UIColor (get-only).
    var blueComponent: Int {
        var b: CGFloat = 0
        getRed(nil, green: nil, blue: &b, alpha: nil)
        return Int(b * 255)
    }

    /// RGB component of UIColor (get-only).
    var rgb: (CGFloat, CGFloat, CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return (red * 255, green * 255, blue * 255)
    }

    /// Alpha of UIColor (get-only).
    var alpha: CGFloat {
        var a: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &a)
        return a
    }
}
