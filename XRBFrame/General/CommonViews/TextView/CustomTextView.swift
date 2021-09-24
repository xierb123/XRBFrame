//
//  CustomTextView.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {
    var maximumLength: Int = 10000
    var textChangedHandler: ((String) -> Void)?

    override var text: String! {
        didSet {
            if placeholder.count > 0 {
                placeholderLabel.alpha = (text?.count == 0) ? 1 : 0
            }
        }
    }
    
    var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
        
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 4.0, y: 8.0, width: 0.0, height: 0.0))
        label.backgroundColor = UIColor.clear
        label.lineBreakMode = .byWordWrapping
        label.font = self.font
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func draw(_ rect: CGRect) {
        if !placeholder.isEmpty {
            placeholderLabel.text = placeholder
            placeholderLabel.textColor = self.placeholderColor
            placeholderLabel.alpha = (text?.count == 0) ? 1 : 0
            addSubview(placeholderLabel)
            
            placeholderLabel.sizeToFit()
            sendSubviewToBack(placeholderLabel)
        }
        
        super.draw(rect)
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        if placeholder.count > 0 {
            placeholderLabel.alpha = (text.count == 0) ? 1 : 0
        }

        if let range = markedTextRange {
            let offset = self.offset(from: beginningOfDocument, to: range.start)
            if offset < maximumLength {
                return
            }
        }
        
        if text.count > maximumLength {
            let index = text.index(text.startIndex, offsetBy: maximumLength)
            text = String(text[..<index])
        }
        textChangedHandler?(text)
    }
}
