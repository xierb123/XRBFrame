//
//  UIAlertControllerExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

var subviews : [UIView]?
extension UIAlertController{
    var titleLabel : UILabel?{
        set{
            
        }
        get{
            if viewArray(root: self.view) != nil {
                return viewArray(root: self.view)![1] as? UILabel
            }
            return nil
        }
    }
    var messageLabel : UILabel?{
        set{
            
        }
        get{
            if viewArray(root: self.view) != nil {
                return viewArray(root: self.view)![2] as? UILabel
            }
            return nil
        }
    }
    @discardableResult
    func viewArray(root:UIView) -> [UIView]?{
        subviews = nil
        for item in root.subviews{
            if subviews != nil {
                break
            }
            if item is UILabel{
                subviews = root.subviews
                return subviews!
            }
            viewArray(root: item)
        }
        return subviews
    }
}
