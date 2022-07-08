//
//  CodeBlockViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/26.
//

import UIKit

class CodeBlockViewController: BaseViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        showBlock()
        showBlock2()
        
        let block = showBlock3()
        printLog(block(10, 15))
        
        showBlock4(with: "张三") { name in
            printLog(name)
        }
        
        showBlock5()
        showBlock6()
        showBlock7()
    }
    
    private func showBlock() {
        var volunteerCounts = [1,3,40,32,2,53,77,13]
        volunteerCounts.sort { item1, item2 in
            return item1 < item2
        }
        printLog(volunteerCounts)
    }
    
    /// 可以使用快捷参数替代显式声明参数
    private func showBlock2() {
        var volunteerCounts = [1,3,40,32,2,53,77,13]
        volunteerCounts.sort {
            return $0 < $1
        }
        printLog(volunteerCounts)
    }
    
    /// 函数作为返回值
    private func showBlock3() -> (Int, Int) -> Int {
        func block(a: Int, b: Int) -> Int {
            return a + b
        }
        return block(a:b:)
    }
    
    /// 函数作为参数
    private func showBlock4(with name: String, block: ((String) -> ())? = nil) {
        block?(name)
    }
    
    /// 高阶函数 - map
    private func showBlock5() {
        var array = [1,2,3,4,5,6,7,8,9,10]
        array = array.map({ // 遍历数组内的元素, 返回一个数组
            return $0 + 10
        })
        printLog(array)
    }
    
    /// 高阶函数 - filter
    private func showBlock6() {
        var array = [1,2,3,4,5,6,7,8,9,10]
        let mmarray = array.filter({ // 遍历数组内的元素,将符合条件的元素生成一个新的数组
            return $0 > 5
        })
        printLog(mmarray)
        printLog(array)
    }
    
    /// 高阶函数 - reduce
    private func showBlock7() {
        let array = [0,1,2,3,4,5,6,7,8,9,10]
        let int = array.reduce(10) { a, b in // 遍历数组,累加数据,最后再将初始值累加
            return a + b
        }
        printLog(int)
    }
    

}
