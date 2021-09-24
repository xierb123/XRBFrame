//
//  NoSelectTextView.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

class NoSelectTextView: UITextView {
    override var canBecomeFirstResponder: Bool {
        return false
    }
}
