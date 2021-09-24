//
//  CustomSlider.swift
//  HiconMultiScreen
//
//  Created by devchena on 2020/12/9.
//

import UIKit

class CustomSlider: UISlider {
    var sliderHeight: CGFloat = 6.0 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    private var lastThumbRect: CGRect?
    private var thumbBoundX: CGFloat = 10.0
    private var thumbBoundY: CGFloat = 20.0
    
    override func minimumValueImageRect(forBounds bounds: CGRect) -> CGRect {
        return self.bounds
    }
    
    override func maximumValueImageRect(forBounds bounds: CGRect) -> CGRect {
        return self.bounds
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.trackRect(forBounds: bounds)
        layer.cornerRadius = sliderHeight / 2.0
        return CGRect(x: rect.origin.x, y: (bounds.size.height - sliderHeight) / 2.0, width: bounds.size.width, height: sliderHeight)
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let rect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        lastThumbRect = rect
        return rect
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        guard isUserInteractionEnabled else {
            return result
        }
        
        if point.x < 0.0 || point.x > bounds.size.width {
            return result
        }
        guard let thumbRect = lastThumbRect else {
            return result
        }
        
        if point.y >= -thumbBoundY, point.y < thumbRect.size.height + thumbBoundY {
            var value: Float = 0.0
            value = Float(point.x - bounds.origin.x)
            value = value / Float(bounds.size.width)
            value = value < 0.0 ? 0.0 : value
            value = value > 1.0 ? 1.0 : value
            value = value * (maximumValue - minimumValue) + minimumValue
            setValue(value, animated: true)
        }
        return result
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard isUserInteractionEnabled else {
            return false
        }

        var result = super.point(inside: point, with: event)
        guard let thumbRect = lastThumbRect else {
            return result
        }
        
        if !result, point.y > -10.0 {
            let x = thumbRect.origin.x
            let width = thumbRect.size.width
            let height = thumbRect.size.height
            if point.x >= x - thumbBoundX, point.x <= (x + width + thumbBoundX), point.y < (height + thumbBoundY) {
                result = true
            }
        }
        return result
    }
}
