//
//  UITextFieldExtensions.swift
//  HiconMultiScreen
//
//  Created by 谢汝滨 on 2020/11/26.
//

import UIKit

// MARK: - 调整placeHolder样式
extension UITextField {
    func setDefaultAttributedPlaceholder(withPlaceholder placeholder: String, color: UIColor?, fontSize: CGFloat?) {
        let attributedPlaceholder = NSAttributedString(string: placeholder,
                                                       attributes: [.foregroundColor: color ?? UIColor(hexString: "#C8C8CC")!,
                                                                    .font: UIFont.systemFont(ofSize: fontSize ?? 18.0)])
        self.attributedPlaceholder = attributedPlaceholder
    }
}

extension UITextField {
    /// 自定义clearButton
    func setClearButton(imageName: String, mode: UITextField.ViewMode = .whileEditing, frame: CGRect? = nil) {
        guard let image = UIImage(named: imageName) else {
            return
        }
        
        let clearBtn = UIButton()
        clearBtn.frame = frame ?? CGRect(origin: .zero, size: image.size)
        clearBtn.setImage(image, for: .normal)
        clearBtn.addTarget(self, action: #selector(clear), for: .touchUpInside)
        rightView = clearBtn
        rightViewMode = mode
    }
    
    /// 清空
    @objc func clear() {
        text = ""
    }
}
