//
//  CodeDictionaryViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/26.
//
//  字典

import UIKit

class CodeDictionaryViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showDictionary()
    }
    
    private func showDictionary() {
        var movieRatings = ["邪恶力量":7,
                            "生活大爆炸": 9,
                            "权利的游戏": 8,
                            "行尸走肉":5,
                            "破产姐妹": 7]
        
        var powerRating = movieRatings["权利的游戏"] // 直接通过键值对获取对应的值
        powerRating = 7 // 直接修改值
        
        if let oldValue = movieRatings.updateValue(10, forKey: "生活大爆炸") { // 通过updateValue可以修改数据,而且可以获取到修改之前的值
            printLog("生活大爆炸修改之前的评分为\(oldValue)")
        }
        
        movieRatings["外星人邻居"] = 3 // 直接添加键值对
        
        movieRatings["外星人邻居"] = nil // 直接移除键值对
        
        if let oldValue = movieRatings.removeValue(forKey: "行尸走肉") { // 通过removeValue可以删除数据,而且可以获取到修改之前的值
            printLog("行尸走肉删除之前的评分为\(oldValue)")
        }
        
        for (key, value) in movieRatings { // 循环获取键值对
            printLog("\(key)的评分是\(value)")
        }
        
        for key in movieRatings.keys { // 循环获取键
            printLog(key)
        }
        
        let keysArray = Array(movieRatings.keys) // 使用键创建数组
        printLog(keysArray)
        
        printLog(movieRatings)
    }

}
