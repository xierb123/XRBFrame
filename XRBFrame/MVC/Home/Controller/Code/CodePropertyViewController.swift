//
//  CodePropertyViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/27.
//
//  属性

import UIKit

class CodePropertyViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showProperty()
    }
    
    private func showProperty() {
        
        var town = MyTown()
        printLog(town.townSize)
        printLog(town.mySize)
        printLog(town.secondSize)
        
        printLog(repeatElement("*", count: 33).joined(separator: ""))
        
        town.population = 3000
        printLog(town.townSize)
        printLog(town.mySize)
        printLog(town.secondSize)
        
        printLog(repeatElement("*", count: 33).joined(separator: ""))
        
        town.secondSize = 2000
        printLog(town.secondSize)
        printLog(town.population)
        
        printLog(repeatElement("*", count: 33).joined(separator: ""))
        
        town.description = "这是一个新的城镇"
        
        printLog(repeatElement("*", count: 33).joined(separator: ""))
        
        printLog(MyTown.title)
        
        printLog(repeatElement("*", count: 33).joined(separator: ""))
        
        printLog(town.name)
    }
}

struct MyTown {
    /// 存储属性
    let region: String = "南方"
    var population: Int = 8734
    
    /// 嵌套类型
    enum Size {
        case small
        case middle
        case large
    }
    
    /// 惰性存储属性
    /// 懒加载只会在第一次加载的时候执行一次, 后面不会重新计算
    lazy var townSize: Size = {
        switch population {
        case 0..<1000:
            return .small
        case 1000..<5000:
            return .middle
        default:
            return .large
        }
    }()
    
    /// 计算属性 (只读)
    var mySize: Size {
        get { // 只读属性可省略get
            switch population {
            case 0..<1000:
                return .small
            case 1000..<5000:
                return .middle
            default:
                return .large
            }
        }
    }
    
    /// 计算属性 (读写) - 不可直接设置自身属性
    var secondSize: Int {
        get {
            return population
        }
        set {
            self.population = newValue
        }
    }
    
    /// 属性观察者
    var description: String = "这是一个村子" {
        didSet {
            printLog("设置完成 - 之前的属性是\(oldValue), 新属性是\(description)")
            name = "李四"
        }
        willSet {
            printLog("将要设置 - 之前的属性是\(description), 新属性是\(newValue)")
        }
    }
    
    /// 类属性
    static var title: String = "城镇"
    
    /// 控制读写方法的可见度 (只可在本类内设置, 对外暴露只读)
    private(set) var name = "张三"
}
