//
//  CodeStructAndClassViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/26.
//
//  结构体和类

import UIKit

class CodeStructAndClassViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showStructAndClass()
    }

    func showStructAndClass() {
        var town = Town()
        town.name = "可可西里"
        town.resetName("帕拉梅拉")
        town.printDescription()
        
        let monster = Monster()
        monster.town = town
        monster.attack()
        monster.unDead()
        
        let zombie = Zombie()
        zombie.name = "僵尸"
        zombie.town = town
        zombie.attack()
        zombie.unDead()
    }

}

/// 结构体
struct Town {
    // 结构体属性
    var name: String = "香格里拉"
    var population: Int = 5422 {
        didSet{
            printLog("当前\(name)的人数还有\(population)人")
        }
    }
    var numberOfStopLights = 4
    
    // 结构体方法
    func printDescription() {
        printLog("\(name)是一个有着\(population)人口和\(numberOfStopLights)个交通灯的城镇")
    }
    
    /// mutating方法,用来修改本身属性的值
    mutating func resetName(_ name: String) {
        self.name = name
    }
    
    /// 城镇人数变更
    mutating func changePopulation(by num: Int) {
        population += num
    }
}

/// 类
class Monster {
    var town: Town?
    var name: String = "怪兽"
    
    func attack() {
        if let town = town {
            printLog("\(name)袭击了\(town.name)城镇")
        }
    }
    
    /// final修饰的方法,不可被改写
    final func unDead() {
        printLog("\(name)是不死的")
    }
}

/// 继承
class Zombie: Monster {
    var walkWithLimp = "蹦着"
    override func attack() {
        town?.changePopulation(by: -10)
        super.attack()
    }
}
