//
//  IDCardExtension.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

extension String {
    /// 是否为有效的身份证号码
    var isValidIDCardNumber: Bool {
        let number = self
        // 判断位数
        if number.count != 15 && number.count != 18 {
            return false
        }

        var carid = number
        var lSumQT = 0

        // 加权因子
        let R = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]

        // 校验码
        let sChecker: [Int8] = [49,48,88, 57, 56, 55, 54, 53, 52, 51, 50]

        // 将15位身份证号转换成18位
        let mString = NSMutableString(string: number)

        if number.count == 15 {
            mString.insert("19", at: 6)
            var p = 0
            guard let pid = mString.utf8String else {
                return false
            }
            for i in 0...16 {
                let t = Int(pid[i])
                p += (t - 48) * R[i]
            }
            let o = p % 11
            let stringContent = String(format: "%c", sChecker[o])
            mString.insert(stringContent, at: mString.length)
            carid = mString as String
        }

        let cStartIndex = carid.startIndex
//        let cEndIndex = carid.endIndex
        let index = carid.index(cStartIndex, offsetBy: 2)
        // 判断地区码
        let sProvince = String(carid[cStartIndex..<index])
        if isAreaCodeContain(sProvince) == false {
            return false
        }

        // 判断年月日是否有效
        // 年份
        let yStartIndex = carid.index(cStartIndex, offsetBy: 6)
        let yEndIndex = carid.index(yStartIndex, offsetBy: 4)
        guard let strYear = Int(carid[yStartIndex..<yEndIndex]) else {
            return false
        }

        // 月份
        let mStartIndex = carid.index(yEndIndex, offsetBy: 0)
        let mEndIndex = carid.index(mStartIndex, offsetBy: 2)
        guard let strMonth = Int(carid[mStartIndex..<mEndIndex]) else {
            return false
        }

        // 日
        let dStartIndex = carid.index(mEndIndex, offsetBy: 0)
        let dEndIndex = carid.index(dStartIndex, offsetBy: 2)
        guard let strDay = Int(carid[dStartIndex..<dEndIndex]) else {
            return false
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        guard let _ = dateFormatter.date(from: "\(String(format: "%02d", strYear))-\(String(format: "%02d", strMonth))-\(String(format: "%02d", strDay)) 12:01:01") else {
            return false
        }

        let paperId = carid.utf8CString
        // 检验长度
        if carid.count != 18 {
            return false
        }

        // 校验数字
        func isDigit(c: Int) -> Bool {
            return 0 <= c && c <= 9
        }
        for i in 0...18 {
            let id = Int(paperId[i])
            if isDigit(c: id) && !(88 == id || 120 == id) && 17 == i {
                return false
            }
        }

        // 验证最末的校验码
        for i in 0...16 {
            let v = Int(paperId[i])
            lSumQT += (v - 48) * R[i]
        }
        if sChecker[lSumQT%11] != paperId[17] {
            return false
        }

        return true
    }

    private func isAreaCodeContain(_ code: String) -> Bool {
        var dict: [String: String] = [:]
        dict["11"] = "北京"
        dict["12"] = "天津"
        dict["13"] = "河北"
        dict["14"] = "山西"
        dict["15"] = "内蒙古"
        dict["21"] = "辽宁"
        dict["22"] = "吉林"
        dict["23"] = "黑龙江"
        dict["31"] = "上海"
        dict["32"] = "江苏"
        dict["33"] = "浙江"
        dict["34"] = "安徽"
        dict["35"] = "福建"
        dict["36"] = "江西"
        dict["37"] = "山东"
        dict["41"] = "河南"
        dict["42"] = "湖北"
        dict["43"] = "湖南"
        dict["44"] = "广东"
        dict["45"] = "广西"
        dict["46"] = "海南"
        dict["50"] = "重庆"
        dict["51"] = "四川"
        dict["52"] = "贵州"
        dict["53"] = "云南"
        dict["54"] = "西藏"
        dict["61"] = "陕西"
        dict["62"] = "甘肃"
        dict["63"] = "青海"
        dict["64"] = "宁夏"
        dict["65"] = "新疆"
        dict["71"] = "台湾"
        dict["81"] = "香港"
        dict["82"] = "澳门"
        dict["91"] = "国外"

        return dict[code] != nil
    }
}
