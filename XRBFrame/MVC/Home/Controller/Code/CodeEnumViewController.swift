//
//  CodeEnumViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/26.
//
//  枚举

import UIKit

class CodeEnumViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showEnum()
        showEnum2()
        showEnum3()
        showEnum4()
    }
    
    /// 基本枚举
    private func showEnum() {
        enum Enum1 {
            case left
            case right
            case top
            case bottom
            
            func logRawValue() {
                switch self {
                case .left:
                    printLog("左侧")
                case .right:
                    printLog("右侧")
                case .top:
                    printLog("上侧")
                case .bottom:
                    printLog("底侧")
                }
            }
        }
        
        let enum1 = Enum1.left
        enum1.logRawValue()
    }
    
    /// 原始值枚举
    private func showEnum2() {
        enum Enum2: Int {
            case left     = 10
            case right    = 20
            case top      = 30
            case bottom   = 40
        }
        
        let value = 30
        if let enum2 = Enum2(rawValue: value) { // 可以根据rawValue来获取枚举值
            printLog("可以根据值获取到枚举值 - \(enum2)")
        } else {
            printLog("获取不到枚举值")
        }
    }
    
    /// 枚举方法
    private func showEnum3() {
        enum Enum3 {
            case on
            case off
            
            mutating func reset() {
                self = self == .on ? .off : .on
            }
            
            mutating func reset2() {
                switch self {
                case .on:
                    self = .off
                case .off:
                    self = .on
                }
            }
        }
        
        var lightStyle = Enum3.on
        lightStyle.reset()
        lightStyle.reset2()
        printLog(lightStyle)
    }
    
    /// 关联值
    /// 关联值可以将数据绑定枚举实例；不同的成员可以有不同类型的关联值。
    private func showEnum4() {
        enum Enum4 {
            case square(side: Double)
            case recrangle(width: Double, height: Double)
            
            func getArea() -> Double {
                switch self {
                case .square(let side):
                    return side * side
                case .recrangle(let width, let height):
                    return width * height
                }
            }
            
            func getPerimeter() -> Double {
                switch self {
                case .square(let side):
                    return side * 4.0
                case .recrangle(let width, let height):
                    return (width + height) * 2.0
                }
            }
        }
        
        let area = Enum4.square(side: 12.0)
        printLog(area.getArea())
        printLog(area.getPerimeter())
    }
}
