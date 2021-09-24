//
//  CodeInitViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/27.
//
//  初始化

import UIKit

class CodeInitViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /// 自定义初始化
        //let struct1 = MyStruct(name: <#String#>, ageNum: <#Int#>)
        /// 委托初始化
        //let struct2 = MyStruct(name: <#T##String#>)
        
        /// 指定初始化
        //let class1 = MyClass(name: <#String#>, ageNum: <#Int#>)
        /// 便捷初始化
        //let class2 = MyClass(name: <#T##String#>)
        /// 可失败的初始化
        let class3 = MyClass(name: "张三", ageNumber: -34)
        printLog(class3)
        
    }
}

/// 结构体初始化
struct MyStruct {
    var name: String
    var age: Int
    
    // 如果没有自定义初始化方法, 会有默认初始化方法
    
    /// 自定义初始化 - 会取代默认初始化方法
    init(name: String, ageNum: Int) {
        self.name = name
        self.age = ageNum
    }
    
    /// 委托初始化 - 通过调用另外的初始化方法实现初始化,没有调用的属性会提供默认值
    init(name: String) {
        self.init(name: name, ageNum: 12)
    }
}

/// 类初始化
class MyClass {
    // 如果没有提供初始化方法,需要为属性提供默认值
    var name: String = ""
    var age: Int = 0
    
    /// 指定初始化
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    /// 便捷初始化
    convenience init(name: String) {
        self.init(name: name, age: 12)
    }
    
    /// 必需初始化 - 子类必须
    required init(name: String, ageNum: Int) {
        self.name = name
        self.age = ageNum
    }
    
    /// 析构
    deinit {
        printLog("对象被销毁")
    }
    
    /// 可失败的初始化 - 当属性的复制不满足某些条件时,可以返回nil,初始化失败
    init?(name: String, ageNumber: Int) {
        guard ageNumber > 0 else{
            return nil
        }
        self.name = name
        self.age = ageNumber
    }
}


