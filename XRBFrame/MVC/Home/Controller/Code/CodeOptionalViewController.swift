//
//  CodeOptionalViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/25.
//
//  可空类型

import UIKit

class CodeOptionalViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showOptional()
        showOptional2()
        showOptional3()
        showOptional4()
    }
    
    /// 可空实例绑定
    private func showOptional() {
        var item: Int? = 12
        var str: String?
        if let item = item {
            printLog(item)
        }
        if let item = item, let str = str {
            printLog("item和str都有值")
        } else {
            printLog("至少存在一个空类型")
        }
    }
    
    /// 可空链式调用
    private func showOptional2() {
        var str: String?
        if let item = str?.toInt(){  // 链式点语法中,有一个为空,则返回nil
            printLog(item)
        } else {
            printLog("函数链包含nil")
        }
    }
    
    /// 原地修改可空类型
    private func showOptional3() {
        var str: String?
        let item = str?.appending("现在不为空了") // 类似于可空链式调用,对象为nil的时候返回nil,其他情况正常操作
        printLog(item)
    }
    
    /// nil 合并运算符
    private func showOptional4() {
        var str: String?
        printLog(str ?? "空类型") // ??相当于给出一个默认值,当值为nil的时候,返回默认值
    }
}
