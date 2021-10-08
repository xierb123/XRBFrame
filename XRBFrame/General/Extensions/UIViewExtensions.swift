//
//  UIViewExtensions
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

// MARK: - Initializers
extension UIView {
    /// Convenience contructor to define a view based on width, height and base coordinates.
    @objc convenience init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(frame: CGRect(x: x, y: y, width: width, height: height))
    }
}

// MARK: - Properties
extension UIView {
    /// Getter and setter for the x coordinate of the frame's origin for the view.
    var x: CGFloat {
        get {
            return self.frame.origin.x
        } set(value) {
            self.frame = CGRect(x: value, y: self.y, width: self.width, height: self.height)
        }
    }

    /// Getter and setter for the y coordinate of the frame's origin for the view.
    var y: CGFloat {
        get {
            return self.frame.origin.y
        } set(value) {
            self.frame = CGRect(x: self.x, y: value, width: self.width, height: self.height)
        }
    }

    /// Variable to get the width of the view.
    var width: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: value, height: self.height)
        }
    }

    /// Variable to get the height of the view.
    var height: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: self.width, height: value)
        }
    }

    /// Getter and setter for the x coordinate of leftmost edge of the view.
    var left: CGFloat {
        get {
            return self.x
        } set(value) {
            self.x = value
        }
    }

    /// Getter and setter for the x coordinate of the rightmost edge of the view.
    var right: CGFloat {
        get {
            return self.x + self.width
        } set(value) {
            self.x = value - self.width
        }
    }

    /// Getter and setter for the y coordinate for the topmost edge of the view.
    var top: CGFloat {
        get {
            return self.y
        } set(value) {
            self.y = value
        }
    }

    /// Getter and setter for the y coordinate of the bottom most edge of the view.
    var bottom: CGFloat {
        get {
            return self.y + self.height
        } set(value) {
            self.y = value - self.height
        }
    }

    /// Getter and setter the frame's origin point of the view.
    var origin: CGPoint {
        get {
            return self.frame.origin
        } set(value) {
            self.frame = CGRect(origin: value, size: self.frame.size)
        }
    }

    /// Getter and setter for the X coordinate of the center of a view.
    var centerX: CGFloat {
        get {
            return self.center.x
        } set(value) {
            self.center.x = value
        }
    }

    /// Getter and setter for the Y coordinate for the center of a view.
    var centerY: CGFloat {
        get {
            return self.center.y
        } set(value) {
            self.center.y = value
        }
    }

    /// Getter and setter for frame size for the view.
    var size: CGSize {
        get {
            return self.frame.size
        } set(value) {
            self.frame = CGRect(origin: self.frame.origin, size: value)
        }
    }
}

// MARK: - Methodss
extension UIView {
    /// Add array of subviews to view.
    ///
    /// - Parameter subviews: array of subviews to add to self.
    public func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }

    /// Remove all subviews in view.
    func removeSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
}

extension UIView {
    /// Set corner radius of view.
    ///
    /// - Parameters:
    ///   - radius: radius for all four corners.
    func setCornerRadius(_ radius: CGFloat, masksToBounds: Bool = false) {
        layer.cornerRadius = radius
        layer.masksToBounds = masksToBounds
    }

    /// Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))

        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = maskPath.cgPath
        layer.mask = shapeLayer
    }

    /// Set the border effect.
    ///
    /// - Parameters:
    ///   - width: Border width.
    ///   - color: Border color.
    func setBorder(width: CGFloat,
                   color: UIColor?) {

        layer.borderWidth = width
        layer.borderColor = color?.cgColor
    }

    /// Set the shadow effect.
    ///
    /// - Parameters:
    ///   - color: Shadow color.
    ///   - offset: Shadow offset.
    ///   - opacity: Shadow transparency, default to 1.0.
    ///   - radius: The radius of the fuzzy calculation, default to 5.0.
    func setShadow(color: UIColor,
                   offset: CGSize,
                   opacity: CGFloat = 1.0,
                   radius: CGFloat = 5.0) {

        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = Float(opacity)
        layer.shadowRadius = radius
        layer.shadowOffset = offset
    }
    
    /// Draw dashed line.
    ///
    /// - Parameters:
    ///   - rect: Draw area.
    ///   - width: Dashed line width.
    ///   - radius: Dashed line radius.
    ///   - spacing: Dashed line spacing.
    ///   - color: Dashed line color.
    func drawDashedLine(in rect: CGRect? = nil,
                        width: CGFloat = 0.5,
                        radius: CGFloat? = nil,
                        spacing: Float = 3.0,
                        isDash: Bool = true,
                        color: UIColor) {
        
        let rect = rect ?? bounds
        let shapeLayer = CAShapeLayer()
        if let radius = radius, radius > 0.0 {
            shapeLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath
        } else {
            shapeLayer.path = UIBezierPath(rect: rect).cgPath
        }
        shapeLayer.lineWidth = width
        if isDash {shapeLayer.lineDashPattern = [NSNumber(value: spacing), NSNumber(value: spacing)]}
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        layer.addSublayer(shapeLayer)
    }
}

extension UIView {
    /// Takes screenshot.
    func takeScreenshot(rect: CGRect? = nil) -> UIImage? {
        let rect = rect ?? bounds
        // Begin context
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        // Draw view in that context
        drawHierarchy(in: rect, afterScreenUpdates: true)
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIView {
    public var firstViewController: UIViewController? {
        for view in sequence(first: superview, next: { $0?.superview }) {
            if let responder = view?.next, responder.isKind(of: UIViewController.self) {
                return responder as? UIViewController
            }
        }
        return nil
    }
}
