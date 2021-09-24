//
//  CodeEquatable&ComparableViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/30.
//

import UIKit

class CodeEquatable_ComparableViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showEquatableAndComparable()
    }
    
    func showEquatableAndComparable() {
        
        let a = Point(x: 3, y: 4)
        let b = Point(x: 3, y: 4)
        print(a != b)
        print(a<b)
        print(a+b)
        
        let sol = Odin(name: "索尔", age: 8000)
        let loki = Odin(name: "洛基", age: 7800)
        let gods = [sol,loki]
        let index = gods.firstIndex { god in
            god == sol
        }
        print(index)
    }

}

/// 符合Equatable协议
struct  Point: Equatable {
    enum Error: Swift.Error{
        case xError
        case yError
    }
    
    let x: Int
    let y: Int
    
    /// 自定义相等运算符, 会默认产生产生一个 != 运算符
    static func ==(lhs: Point, rhs:Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    /// 自定义小于运算符
    static func <(lhs: Point, rhs:Point) -> Bool {
        return lhs.x < rhs.x && lhs.y < rhs.y
    }
    
    static func +(lhs: Point, rhs:Point) -> Point {
        return Point(x: lhs.x+rhs.x, y: lhs.y+rhs.y)
    }
}

struct Odin: Equatable {
    var name: String
    var age: Int
    
    static func ==(a:Odin, b:Odin) -> Bool{
        return a.name == b.name && a.age == b.age
    }
}

