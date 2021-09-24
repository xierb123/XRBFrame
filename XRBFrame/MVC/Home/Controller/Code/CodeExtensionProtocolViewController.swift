//
//  CodeExtensionProtocolViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/30.
//
//  协议扩展

import UIKit

protocol Exercise {
    /// 锻炼的名字
    var name: String {get}
    /// 消耗的卡路里
    var caloriesBurned: Double {get}
    /// 锻炼时长
    var minutes: Double {get}
    
    func description()
}
/// 协议扩展 - 可用来添加默认实现
extension Exercise {
    /// 平均卡路里
    var caloriesBurnedPerMinute: Double {
        return caloriesBurned / minutes
    }
    
    func description() {
        printLog("这是一场名叫\(name)的运动")
    }
}

class CodeExtensionProtocolViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showExtension()
        
    }
    
    private func showExtension() {
        
        let exercise = EllipticalWorkout()
        printLog(exercise.caloriesBurnedPerMinute)
        
        exercise.description()
    }
    
}

struct  EllipticalWorkout: Exercise {
    var name: String = "跳绳"
    
    var caloriesBurned: Double = 300.0
    
    var minutes: Double = 30.0

    
}
