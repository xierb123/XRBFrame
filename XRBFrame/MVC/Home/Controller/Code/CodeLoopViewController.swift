//
//  CodeLoopViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/25.
//
//  循环

import UIKit

class CodeLoopViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showLoop()
        showLoop2()
        showLoop3()
        showLoop4()
        showLoop5()
        showLoop6()
    }
    
    /// for - in 循环
    private func showLoop() {
        for i in 0...5{
            printLog(i)
        }
    }
    
    /// where子句
    private func showLoop2() {
        for i in 0...10 where i % 2 == 0 {  // 通过where子句可以添加循环的判断条件
            printLog(i)
        }
    }
    
    /// while循环
    private func showLoop3() {
        var item = 0
        while(item <= 10) {
            if item % 2 == 0 {
                printLog(item)
            }
            item += 1
        }
    }
    
    /// repeat - while循环(保证至少可以循环一次)
    private func showLoop4() {
        var item = 0
        repeat {
            if item % 2 == 0 {
                printLog(item)
            }
            item += 1
        } while item <= 10
    }
    
    /// 循环控制转移语句
    private func showLoop5() {
        for i in 0...10 {
            if i == 3 {
                continue  // continue: 本次的循环直接结束,跳到下一次循环
            }
            if i == 7 {
                break // break: 循环结束
            }
            printLog(i)
        }
        return // return: 直接跳出函数
    }
    
    /// 循环联系
    private func showLoop6() {
        for i in 0...20 {
            switch i {
            case let code where (code % 3 == 0 && code % 5 == 0):
                print("FIZZ BUZZ")
            case let code where (code % 3 == 0):
                print("FIZZ")
            case let code where (code % 5 == 0):
                print("BUZZ")
            default:
                print(i)
            }
        }
    }
}
