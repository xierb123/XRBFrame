//
//  CodeArrayViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/26.
//
//  数组

import UIKit

class CodeArrayViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showArray()
    }
    
    private func showArray() {
        var fruitsList = ["苹果"]
        fruitsList.append("香蕉") // 数组可以直接添加元素
        fruitsList.append("榴莲")
        fruitsList.append("葡萄")
        fruitsList.append("猕猴桃")
        fruitsList.append("草莓")
        
        fruitsList.remove(at: 2)  // 数组可以通过索引移除元素
        
        fruitsList[2] += "干"  // 数组的元素可以直接操作
        
        fruitsList[0] = "橘子" // 替换元素
        
        fruitsList += ["西瓜","芒果"] // 数组可以直接用+=添加数组
        
        fruitsList.insert("杏", at: 3) // 在指定位置插入元素
        
        fruitsList.removeAll { item  in // 移除指定元素
            return item == "草莓"
        }
        
        printLog(fruitsList[0...3]) // 可以通过下标直接获取数组的部分元素
        
        printLog(fruitsList.enumerated().reversed()) // 数组反向排列
        
        if let index = fruitsList.firstIndex(of: "西瓜"), index <= fruitsList.count-3 {
            print(fruitsList[index+2])
        }
        
        printLog(fruitsList)
    }
}

