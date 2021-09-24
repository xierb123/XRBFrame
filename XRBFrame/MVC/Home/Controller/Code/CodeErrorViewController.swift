//
//  CodeErrorViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/27.
//
//  错误处理

import UIKit


class CodeErrorViewController: BaseViewController {
    
    /// 定义异常类型
    enum Error: Swift.Error {
        case tooSmall
        case tooLarge
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        /// 这是一种捕获异常的方法,通过系统方法获取异常类型
        do {
            try getNumber(550)
        } catch {
            printLog(error)
        }
        
        /// 也可以把具体的异常类型列举出来单独处理
        do {
            try getNumber(1234)
        } catch Error.tooLarge {
            printLog("输入的数字过大")
        } catch Error.tooSmall {
            printLog("输入的数字过小")
        } catch {
            print(error)
        }
    }
    
    // 使用throws标记该方法可能抛出异常
    func getNumber(_ num: Int) throws {
        if num < 500 {
            // 抛出异常
            throw Error.tooSmall
        } else if num > 1000 {
            throw Error.tooLarge
        }
        printLog(num)
    }
}
