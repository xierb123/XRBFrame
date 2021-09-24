//
//  UIDatePickerExtensions.swift
//  HiconMultiScreen
//
//  Created by devchena on 2021/6/8.
//

import Foundation

extension UIDatePicker {
    var textColor: UIColor? {
        set {
            guard let color = newValue else {
                return
            }
            setValue(color, forKeyPath: "textColor")
        }
        get {
            return value(forKeyPath: "textColor") as? UIColor
        }
    }
    
    var highlightsToday: Bool? {
        set {
            guard let highlights = newValue else {
                return
            }
            setValue(highlights, forKeyPath: "highlightsToday")
        }
        get {
            return value(forKeyPath: "highlightsToday") as? Bool
        }
    }
}
