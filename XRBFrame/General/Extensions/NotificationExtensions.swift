//
//  NotificationExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

extension Notification {
    /// Returns the frame of key board.
    var keyboardFrame: CGRect? {
        guard let value = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return nil
        }
        return value.cgRectValue
    }
    
    /// Returns the animation duration of key board.
    var keyboardAnimationDuration: TimeInterval? {
        guard let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return nil
        }
        return duration
    }
}
