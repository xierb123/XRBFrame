//
//  UILabelExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

// MARK: - Methods
extension UILabel {
    func setText(_ text: String, lineSpacing: CGFloat? = nil) {
        self.attributedText = attributedString(with: text, lineSpacing: lineSpacing)
    }

    /// FIXME: numberOfLines is set to 0.
    func setText(_ text: String, lineSpacing: CGFloat? = nil, frame: CGRect) {
        self.frame = frame
        self.numberOfLines = 0
        self.attributedText = attributedString(with: text, lineSpacing: lineSpacing)
    }

    func addStrikethrough(text: String, color: UIColor, range: NSRange? = nil) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([.strikethroughColor : UIColor(hexString: "#8B8B8B")!,
                                       .baselineOffset : NSNumber(value: NSUnderlineStyle.single.rawValue),
                                       .strikethroughStyle : NSNumber(value: NSUnderlineStyle.single.rawValue)],
                                       range: range ?? NSRange(location: 0, length: text.length))
        attributedText = attributedString
    }
}

extension UILabel {
    private func attributedString(with text: String, lineSpacing: CGFloat? = nil) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        if let lineSpacing = lineSpacing {
            let spacing = frame.height - font.lineHeight
            if frame.height > 0.0, spacing <= lineSpacing {
                paragraphStyle.lineSpacing = 0
            } else {
                paragraphStyle.lineSpacing = lineSpacing
            }
        }

        let attributedString = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttributes([.font: font ?? UIFont.systemFont(ofSize: 17.0)], range: range)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        return attributedString
    }
}

extension UILabel{
    /// 获取Label文字宽度
    func getLabelWidth() -> CGFloat{
        if let str = self.text {
            return (str as NSString).size(withAttributes: [NSAttributedString.Key.font : self.font!]).width
        }
        return 0
    }
    
    /// 获取Label文字高度
    func getLabelHeight(width: CGFloat) -> CGFloat{
        let normalText: NSString = self.text! as NSString
        let size = CGSize(width: width, height:1000)
        let dic = NSDictionary(object: self.font!, forKey : kCTFontAttributeName as! NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key:Any], context:nil).size
        return stringSize.height
     }
    
    /// 设置字号集行间距
    func setFontSize(text: String, font: UIFont, lineSpacing: CGFloat) {
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = lineSpacing
        //样式属性集合
        let attributes = [NSAttributedString.Key.font:font,
                          NSAttributedString.Key.paragraphStyle: paraph]
        self.attributedText = NSAttributedString(string: text, attributes: attributes)
        self.lineBreakMode = .byTruncatingTail
    }
    
    func setHtmlString(_ str: String) {
        do {
            if let data = str.data(using: String.Encoding.unicode, allowLossyConversion: true) {
                let attStr = try NSAttributedString.init(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html,], documentAttributes: nil)
                self.attributedText = attStr
            }
        } catch {
            self.text = str
        }
    }       
}

// 设置文字两端对齐
extension UILabel {
    func textAlignmentLeftAndRightWith(font: UIFont, labelWidth: CGFloat) {
        let text = (self.text ?? "") as NSString
        var attrDic = [NSAttributedString.Key: Any]()
        attrDic.updateValue(font, forKey: NSAttributedString.Key.font)
        
        let size = text.boundingRect(with: CGSize(width: labelWidth, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine, .usesFontLeading], attributes: attrDic, context: nil).size
                
        var length = text.length - 1
        let lastStr = text.substring(with: NSRange(location: length, length: 1))
        var margin = (labelWidth - size.width) / CGFloat(length)
        if lastStr == ":" || lastStr == "：" {
            length = text.length - 2
            //这个10是冒号：这个空隙，使用富文本右对齐，冒号后面会没有空隙，减去这个10实际效果就有空隙了
            margin = (labelWidth - 10 - size.width) / CGFloat(length)
        }
        
        let number = NSNumber(floatLiteral: Double(margin))
        let attribute = NSMutableAttributedString.init(string: text as String)
        attribute.addAttribute(.font, value: font, range: NSRange(location: 0, length: length))
        attribute.addAttribute(.kern, value: number, range:NSRange(location: 0, length: length))
        self.attributedText = attribute;
    }
}
