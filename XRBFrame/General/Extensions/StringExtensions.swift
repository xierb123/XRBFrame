//
//  StringExtensions
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import CommonCrypto

// MARK: - Properties
extension String {
    /// Returns string length.
    var length: Int {
        return self.count
    }

    /// Returns md5 string.
    var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
   }
    
    func substring(from: Int, to: Int) -> String? {
        if from < 0 || to > count || from > to {
            return nil
        }
        
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to)
        return String(self[startIndex..<endIndex])
    }
}

// MARK: - Methods
extension String {
    /// Converts String to Int.
    func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }

    /// Converts String to Double.
    func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }

    /// Converts String to Float.
    func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }

    /// String encoded.
    func encoded() -> String {
        let encodedString = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodedString ?? ""
    }

    /// String decoded.
    func decoded() -> String {
        let decodedString = removingPercentEncoding
        return decodedString ?? ""
    }

    /// String encoded in base64.
    var base64Encoded: String? {
        let plainData = data(using: .utf8)
        return plainData?.base64EncodedString()
    }

    /// String decoded from base64.
    var base64Decoded: String? {
        let remainder = count % 4

        var padding = ""
        if remainder > 0 {
            padding = String(repeating: "=", count: 4 - remainder)
        }

        guard let data = Data(base64Encoded: self + padding,
                              options: .ignoreUnknownCharacters) else { return nil }

        return String(data: data, encoding: .utf8)
    }
    
    /// URL escaped string.
    var urlEncoded: String? {
        let characterSet = NSCharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]").inverted
        return addingPercentEncoding(withAllowedCharacters: characterSet)
    }
    
    /// Readable string from a URL string.
    var urlDecoded: String {
        return removingPercentEncoding ?? self
    }
}

extension String {
    /// Check if string contains one or more emojis.
    ///
    ///        "Hello 😀".containsEmoji -> true
    ///
    var containsEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        for scalar in unicodeScalars {
            if isEmoji(scalar) {
                return true
            }
        }
        return false
    }
    
    /// Check if string contains special character.
    var containsSpecialCharacter: Bool {
        if self.count == 0 {
            return false
        }
        let mobile = "^[\\u4e00-\\u9fa5_a-zA-Z0-9]+$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@", mobile)
        return !regexMobile.evaluate(with: self)
    }

    /// Check if string is valid mobile phone number format.
    var isValidPhoneNumber: Bool {
        if self.count == 0 {
            return false
        }
        // 以13-19开头11位即可
        let mobile = "^[1][3-9]\\d{9}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@", mobile)
        return regexMobile.evaluate(with: self)
    }

    /// Desensitize phone number.
    var desensitizedPhoneNumber: String {
        if isValidPhoneNumber {
            let lower = index(startIndex, offsetBy: 3)
            let upper = index(startIndex, offsetBy: 7)
            let range = Range(uncheckedBounds: (lower, upper))
            return replacingCharacters(in: range, with: "****")
        }
        return self
    }
    
    /// Check if string is valid password format.
    var isValidPassword: Bool {
        // 密码长度8-20位，由数字、小写字符和大写字母组成，要同时含有数字和字母
        let password = "(?!^[0-9]+$)(?!^[A-z]+$)(?!^[^A-z0-9]+$)^.{8,20}$"
        //"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@", password)
        return regexPassword.evaluate(with: self)
    }

    /// Check if string is valid email format.
    var isValidEmail: Bool {
        let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    /// Checks if String contains Chinese.
    func includesChinese() -> Bool {
        for (_, value) in enumerated() {
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        return false
    }
    
    /// Check if string is valid http url format.
    var isValidHttpURL: Bool {
        guard let url = URL(string: self) else {
            return false
        }
        return url.scheme == "http"
    }
    
    /// Check if string is valid https url format.
    var isValidHttpsURL: Bool {
        guard let url = URL(string: self) else {
            return false
        }
        return url.scheme == "https"
    }
}

extension String {
    /// 半角转全角
    /// - Parameter isContainEmoji: 是否含有emoji.
    func halfTurnAngle(isContainEmoji: Bool = false) -> String {
        var angleText = self
        angleText = angleText.replacingOccurrences(of: "~", with: "～")
        angleText = angleText.replacingOccurrences(of: "!", with: "！")
        angleText = angleText.replacingOccurrences(of: "@", with: "＠")
        angleText = angleText.replacingOccurrences(of: "#", with: "＃")
        angleText = angleText.replacingOccurrences(of: "$", with: "＄")
        angleText = angleText.replacingOccurrences(of: "%", with: "％")
        angleText = angleText.replacingOccurrences(of: "^", with: "＾")
        angleText = angleText.replacingOccurrences(of: "&", with: "＆")
        angleText = angleText.replacingOccurrences(of: "*", with: "＊")
        angleText = angleText.replacingOccurrences(of: "(", with: "（")
        angleText = angleText.replacingOccurrences(of: ")", with: "）")
        angleText = angleText.replacingOccurrences(of: "-", with: "－")
        angleText = angleText.replacingOccurrences(of: "_", with: "＿")
        angleText = angleText.replacingOccurrences(of: "+", with: "＋")
        angleText = angleText.replacingOccurrences(of: "=", with: "＝")
        angleText = angleText.replacingOccurrences(of: "{", with: "｛")
        angleText = angleText.replacingOccurrences(of: "}", with: "｝")
        angleText = angleText.replacingOccurrences(of: "/", with: "／")
        angleText = angleText.replacingOccurrences(of: "'", with: "＇")
        angleText = angleText.replacingOccurrences(of: "<", with: "＜")
        angleText = angleText.replacingOccurrences(of: ">", with: "＞")
        angleText = angleText.replacingOccurrences(of: "?", with: "？")
        if isContainEmoji == false { // 包含表情的字符串禁止转换[]
            angleText = angleText.replacingOccurrences(of: "[", with: "［")
            angleText = angleText.replacingOccurrences(of: "]", with: "］")
        }

        return angleText
    }
}

extension String {
    func boundingRect(with constrainedSize: CGSize, font: UIFont, lineSpacing: CGFloat? = nil) -> CGSize {
        let attritube = NSMutableAttributedString(string: self)
        let range = NSRange(location: 0, length: attritube.length)
        attritube.addAttributes([.font: font], range: range)
        if lineSpacing != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing!
            attritube.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        }

        let rect = attritube.boundingRect(with: constrainedSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        var size = rect.size

        if let currentLineSpacing = lineSpacing {
            // 计算后的高度减去字体高度小于或等于行间距，判断为当前只有1行
            let spacing = size.height - font.lineHeight
            if spacing <= currentLineSpacing && spacing > 0 {
                size = CGSize(width: size.width, height: font.lineHeight)
            }
        }

        return size
    }

    /// FIXME: 建议配合UILabel的扩展方法
    /// 'func setText(_ text: String, lineSpacing: CGFloat? = nil, frame: CGRect)'使用.
    func boundingRect(with constrainedSize: CGSize, font: UIFont, lineSpacing: CGFloat? = nil, lines: Int) -> CGSize {
        if lines < 0 {
            return .zero
        }

        let size = boundingRect(with: constrainedSize, font: font, lineSpacing: lineSpacing)
        if lines == 0 {
            return size
        }

        let currentLineSpacing = (lineSpacing == nil) ? (font.lineHeight - font.pointSize) : lineSpacing!
        let maximumHeight = font.lineHeight*CGFloat(lines) + currentLineSpacing*CGFloat(lines - 1)
        if size.height >= maximumHeight {
            return CGSize(width: size.width, height: maximumHeight)
        }

        return size
    }
}

extension String {
    /// 返回第一次出现的指定子字符串在此字符串中的索引
    ///（如果backwards参数设置为true，则返回最后出现的位置）
    func positionOf(sub: String, backwards: Bool = false)->Int {
        var pos = -1
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }

    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    /// 处理包含html标签的字符串
    var htmlToString: String {
        return htmlToAttributedString?.string ?? self
    }
    
    /// 移除<img>标签
    func removeHtmlImg() -> String {
        let pattern = "<img[^>]*>"
        //替换后的字符串
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let finalString = regex.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.count), withTemplate: "")
        return finalString
    }
    
    /// 移除所有HTML标签
    func removeHtmlLabel() -> String {
        let pattern = "<[^>]*>"
        //替换后的字符串
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let finalString = regex.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.count), withTemplate: "")
        return finalString
    }
    
    /// 移除emoji表情
    func removeEmojis() -> String {
        var scalars = self.unicodeScalars
        scalars.removeAll(where: isEmoji)
        return String(scalars)
    }
    
    /// 判断是否是emoji表情
    func isEmoji(_ scalar: Unicode.Scalar) -> Bool {
        switch Int(scalar.value) {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F1E6...0x1F1FF, // Regional country flags
        0x2600...0x26FF, // Misc symbols
        0x2700...0x27BF, // Dingbats
        0xE0020...0xE007F, // Tags
        0xFE00...0xFE0F, // Variation Selectors
        0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
        127000...127600, // Various asian characters
        65024...65039, // Variation selector
        9100...9300, // Misc items
        8400...8447: // Combining Diacritical Marks for Symbols
            return true
        default:
            return false
        }
    }
}

extension String{
    /// check string cellection is whiteSpace
    var isBlank : Bool{
        return allSatisfy({$0.isWhitespace})
    }
}

extension Optional where Wrapped == String{
    var isBlank : Bool{
        return self?.isBlank ?? true
    }
}

extension String{
    
    static func format(decimal:Float, _ maximumDigits:Int = 1, _ minimumDigits:Int = 1) -> String? {
        let number = NSNumber(value: decimal)
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = maximumDigits //设置小数点后最多2位
        numberFormatter.minimumFractionDigits = minimumDigits //设置小数点后最少2位（不足补0）
        return numberFormatter.string(from: number)
    }
    
    func setOmitted(with maxLength: Int) -> String {
        return self.length > maxLength ? String(self.prefix(maxLength))+"..." : self
    }
    
    func urlScheme(scheme:String) -> URL? {
        if let url = URL.init(string: self) {
            var components = URLComponents.init(url: url, resolvingAgainstBaseURL: false)
            components?.scheme = scheme
            return components?.url
        }
        return nil
    }
    
    //根据正则表达式改变文字颜色
    func changeTextChange(regex: String, text: String, color: UIColor,font:CGFloat) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: text)

        do {
            let regexExpression = try NSRegularExpression(pattern: regex, options: NSRegularExpression.Options())
            let result = regexExpression.matches(in: text, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, text.count))
            for item in result {
//                attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: item.range)
                attributeString.addAttributes([NSAttributedString.Key.foregroundColor:color,NSAttributedString.Key.font:UIFont.systemFont(ofSize: font)], range: item.range)
            }
        } catch {
            print("Failed with error: \(error)")
        }

        return attributeString
    }
    
    func isPhoneNumber() -> Bool {
//        let mobileRegex = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(19[0,0-9])|(17[0,0-9]))\\d{8}$"
        let mobileRegex = "^((13[0-9])|(14[0-9])|(15[^4,\\D])|(16[0-9])|(17[0-9])|(18[0,0-9])|(19[0,0-9]))\\d{8}$"
        let mobileTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
        return mobileTest.evaluate(with: self)
    }
    
    func changeRangeText(range:NSRange, text: String, color: UIColor,font:CGFloat) -> NSMutableAttributedString{
        let attributeString = NSMutableAttributedString(string: text)
            
        // 3. 在生成的 NSMutableAttributedString 对象中修改前两位的颜色
        attributeString.setAttributes(
            [NSAttributedString.Key.foregroundColor : color,NSAttributedString.Key.font:UIFont.systemFont(ofSize: font)],
            range: range
        )

        return attributeString
    }
    
    func changeRangeBoldText(range:NSRange, text: String, color: UIColor,font:CGFloat) -> NSMutableAttributedString{
        let attributeString = NSMutableAttributedString(string: text)
            
        // 3. 在生成的 NSMutableAttributedString 对象中修改前两位的颜色
        attributeString.setAttributes(
            [NSAttributedString.Key.foregroundColor : color,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: font)],
            range: range
        )

        return attributeString
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        
        let utf16view = self.utf16
        
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
            
        }
        
        return nil
    }
    
    private func getNormalStrSize(str: String? = nil, attriStr: NSMutableAttributedString? = nil, font: CGFloat, w: CGFloat, h: CGFloat) -> CGSize {
        if str != nil {
            let strSize = (str! as NSString).boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: font)], context: nil).size
            return strSize
        }
        
        if attriStr != nil {
            let strSize = attriStr!.boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, context: nil).size
            return strSize
        }
        
        return CGSize.zero
    }
    
    private func getNormalStrSize(str: String? = nil, attriStr: NSMutableAttributedString? = nil, font: UIFont, w: CGFloat, h: CGFloat) -> CGSize {
        if str != nil {
            let strSize = (str! as NSString).boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
            return strSize
        }
        
        if attriStr != nil {
            let strSize = attriStr!.boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, context: nil).size
            return strSize
        }
        
        return CGSize.zero
    }
    
    /**获取字符串高度H*/
    func getFontNormalStrH(str: String, strFont: UIFont, w: CGFloat) -> CGFloat {
        return getNormalStrSize(str: str, font: strFont, w: w, h: CGFloat.greatestFiniteMagnitude).height
    }
    
    /**获取字符串高度H*/
    func getNormalStrH(str: String, strFont: CGFloat, w: CGFloat) -> CGFloat {
        return getNormalStrSize(str: str, font: strFont, w: w, h: CGFloat.greatestFiniteMagnitude).height
    }
    
    /**获取字符串宽度W*/
    func getNormalStrW(str: String, strFont: CGFloat, h: CGFloat) -> CGFloat {
        return getNormalStrSize(str: str, font: strFont, w: CGFloat.greatestFiniteMagnitude, h: h).width
    }
    
    /**获取富文本字符串高度H*/
    func getAttributedStrH(attriStr: NSMutableAttributedString, strFont: CGFloat, w: CGFloat) -> CGFloat {
        return getNormalStrSize(attriStr: attriStr, font: strFont, w: w, h: CGFloat.greatestFiniteMagnitude).height
    }
    
    /**获取富文本字符串宽度W*/
    func getAttributedStrW(attriStr: NSMutableAttributedString, strFont: CGFloat, h: CGFloat) -> CGFloat {
        return getNormalStrSize(attriStr: attriStr, font: strFont, w: CGFloat.greatestFiniteMagnitude, h: h).width
    }
    
    func beforeStringAddImage(imageName:String,str:String,x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat) -> NSMutableAttributedString{
        let img = UIImage(named: imageName)
        let textAttach = NSTextAttachment.init()
        textAttach.image = img
        textAttach.bounds = CGRect(x: x, y: y, width: width, height: height)
        let attributedStr = NSAttributedString(attachment: textAttach)
        let attri = NSMutableAttributedString.init(string: str)
        attri.insert(attributedStr, at: 0)
        return attri
    }
    
    /// 替换手机号中间四位
    ///
    /// - Returns: 替换后的值
    func replacePhone() -> String {
        if self == "" {
            return ""
        }
        let start = self.index(self.startIndex, offsetBy: 3)
        let end = self.index(self.startIndex, offsetBy: 7)
        let range = Range(uncheckedBounds: (lower: start, upper: end))
        return self.replacingCharacters(in: range, with: "****")
    }
    
    func moneyToYuan() -> String{
        let d = self.toDouble() ?? 0
        let w = CGFloat(d)/100
        var money = String(format: "%.2f", w)
        
        if money.hasSuffix("0") && !money.hasSuffix(".00") {
            money = self.moneyToOneYuan()
        }
        money = money.hasSuffix(".00") ? self.moneyToIntYuan() : money
        return money
    }
    
    func moneyToIntYuan() -> String{
        let d = self.toDouble() ?? 0
        let w = CGFloat(d)/100
        return String(format: "%.0f", w)
    }
    func moneyToOneYuan() -> String{
        let d = self.toDouble() ?? 0
        let w = CGFloat(d)/100
        return String(format: "%.1f", w)
    }
    
    //字符串转时间戳
    func timeStrChangeTotimeInterval(timeStr: String?, dateFormat:String?) -> String {
        if timeStr?.count ?? 0 <= 0 {
            return ""
        }
        let format = DateFormatter.init()
        format.dateStyle = .medium
        format.timeStyle = .short
        if dateFormat == nil {
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            format.dateFormat = dateFormat
        }
        let date = format.date(from: timeStr ?? "")
        return String(date?.timeIntervalSince1970 ?? 0)
    }
    
    //时间戳转成字符串
    func timeIntervalChangeToTimeStr(timeInterval:TimeInterval, dateFormat:String?) -> String {
        let date:NSDate = NSDate.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        if dateFormat == nil {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            formatter.dateFormat = dateFormat
        }
        return formatter.string(from: date as Date)
    }
}

// 小驼峰命名与下划线命名切换
extension String {
    // - 小驼峰转化为下划线命名
    func namedByUnderline() -> String {
        var value = ""
        let _ = self.map {
            if ("A"..."Z").contains($0) {
                value += "_\($0.lowercased())"
                return
            }
            value += "\($0)"
        }
        return value
    }
    
    // - 下划线转化为驼峰命名
    func namedByHump() -> String {
        var value = ""
        var toUpper = false
        let _ = self.map {
            if $0 == "_" {
                toUpper = true
                return
            }
            value += toUpper ? "\($0.uppercased())" : "\($0)"
            toUpper = false
        }
        return value
    }
}

