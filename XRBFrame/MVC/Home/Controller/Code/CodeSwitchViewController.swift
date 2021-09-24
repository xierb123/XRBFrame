//
//  CodeSwitchViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/25.
//
//  Switch语句

import UIKit

class CodeSwitchViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showSwitch()
        showSwitch2()
        showSwitch3()
        showSwitch4()
        showSwitch5()
        showSwitch6()
    }
    
    /// 普通的Switch语句
    private func showSwitch() {
        var statusCode: Int = 404
        switch statusCode {
        case 400:
            printLog("Bad Request")
        case 401:
            printLog("Unauthorized")
        case 403:
            printLog("Forbidden")
        case 404:
            printLog("Not Found")
        default:
            printLog("None")
        }
    }
    
    /// 单个Switch分支匹配多个值
    private func showSwitch2() {
        var statusCode: Int = 404
        switch statusCode {
        case 400, 401, 403, 404:
            printLog("网络访问出错")
            fallthrough  // 透传,本分支匹配成功之后,可以继续匹配下面的分支
        default:
            printLog("None")
        }
    }
    
    /// 单个Switch分支区间匹配
    private func showSwitch3() {
        var statusCode: Int = 404
        switch statusCode {
        case 101, 102:
            printLog("当前数据落在了101 和 102")
        case 204:
            printLog("当前数据落在了204")
        case 400...404:
            printLog("当前数据落在了400到404之间")
        default:
            printLog("None")
        }
    }
    
    /// 值绑定
    private func showSwitch4() {
        var statusCode: Int = 406
        switch statusCode {
        case 101, 102:
            printLog("当前数据落在了101 和 102")
        case 204:
            printLog("当前数据落在了204")
        case 400...404:
            printLog("当前数据落在了400到404之间")
        case let unKownCode:  // 可以通过let关键词绑定数据
            printLog("不知道这个\(unKownCode)是什么错误")
        }
    }
    
    /// where子句
    private func showSwitch5() {
        var statusCode: Int = 906
        switch statusCode {
        case 101, 102:
            printLog("当前数据落在了101 和 102")
        case 204:
            printLog("当前数据落在了204")
        case 400...404:
            printLog("当前数据落在了400到404之间")
        case let unKownCode where (unKownCode >= 500 && unKownCode <= 800): // 可以使用where子句添加多样化的判断条件
            printLog("\(unKownCode)可是一个大错误,但是还不够大")
        case let unKownCode where (unKownCode > 800):
            printLog("\(unKownCode)才是一个大错误")
        default:
            printLog("None")
        }
    }
    
    /// 元组和模式匹配
    private func showSwitch6() {
        var statusCode: Int = 906
        var statusString: String = "用户已注销"
        switch (statusCode, statusString) {
        case (100, "张三"):
            printLog("当前用户是张三")
            fallthrough
        case (_, "李四"):  // _ 可以代表任意数据进行模式匹配
            printLog("当前用户是李四")
            fallthrough
        case (200, _):
            printLog("当前用户是王五")
            fallthrough
        case (906, _):
            printLog("当前的状态码是对的")
            fallthrough
        case (_, "用户已注销"):
            printLog("当前的错误信息是对的")
            fallthrough
        case (_, _):
            printLog("通过模式匹配")
            fallthrough
        default:
            printLog("None")
        }
    }
}
