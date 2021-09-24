//
//  CodeExtensionViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/27.
//
//  扩展

import UIKit

class CodeExtensionViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showExtension()
        showExtension2()
       
    }
    
    private func showExtension() {
        let str = "我是一个兵"
        printLog(str.getCount())
    }
    
    private func showExtension2() {
        let car = Car(displacement: 1.9, year: 2018, color: "白", nickName: "帕拉梅拉")
        printLog(car.description)
        var displacement = ""
        do {
            try displacement = car.size.showDisplacement()
        } catch {
            printLog(error)
        }
        guard !displacement.isEmpty else {
            return
        }
        printLog("\(car.nickName)是一辆\(displacement)的车")
        
        car.showCar()
    }

}

/// 拓展已有的类型
extension String {
    func getCount() -> Int {
        return self.count
    }
}

/// 扩展自己的类型
struct Car {
    let make: String
    let modal: String
    let year: Int
    let color: String
    let nickName: String
    let displacement: Double
}

/// 用扩展使类型符合协议
extension Car: CustomStringConvertible {
    var description: String {
        return "这是一辆\(year)年生产的,\(color)色的\(nickName)"
    }
}

/// 用扩展添加初始化方法
extension Car {
    init(displacement: Double, year: Int, color: String, nickName: String) {
        self.init(make: "汽油", modal: "发送机", year: year, color: color, nickName: nickName, displacement: displacement)
    }
}

/// 用扩展添加嵌套类型
extension Car {
    enum Error: Swift.Error {
        case unKnown
    }
    enum Size {
        case small
        case large
        case error
        
        func showDisplacement() throws -> String {
            switch self {
            case .small:
                return "小排量"
            case .large:
                return "大排量"
            case .error:
                throw Error.unKnown
            }
        }
    }
    
    var size: Size {
        switch displacement {
        case 0..<2:
            return .small
        case let displacement where (displacement > 2):
            return .large
        default:
            return .error
        }
    }
}

/// 用扩展添加函数
extension Car {
    func showCar() {
        printLog("\(nickName)跑的可快了")
    }
}
