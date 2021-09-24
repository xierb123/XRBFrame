//
//  CustomTextField.swift
//  HiconMultiScreen
//
//  Created by devchena on 2021/6/25.
//

import UIKit

class CustomTextField: UITextField {
    var maximumLength: Int = 10000
    var editingChangedHandler: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func editingChanged() {
        guard let text = text else {
            return
        }
        
        if let range = markedTextRange {
            let offset = self.offset(from: beginningOfDocument, to: range.start)
            if offset < maximumLength {
                return
            }
        }
        
        if text.count > maximumLength {
            let index = text.index(text.startIndex, offsetBy: maximumLength)
            self.text = String(text[..<index])
        }
        
        editingChangedHandler?(text)
    }
}
