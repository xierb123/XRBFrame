//
//  CodeSetViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/26.
//
//  集合

import UIKit

class CodeSetViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showSet()
    }
    
    private func showSet() {
        var fruits1: Set = ["苹果","香蕉","菠萝","橘子","葡萄","苹果"] // 集合内的元素互不相同且无序
        var fruits2: Set = ["西瓜","草莓","香蕉","杏","葡萄","梨"]
        
        fruits1.insert("石榴") // 添加元素
        printLog(fruits1)
        
        var set1 = fruits1.union(fruits2) // 并集
        printLog(set1)
        
        var set2 = fruits1.intersection(fruits2) // 交集
        printLog(set2)
        
        var set3 = fruits1.isDisjoint(with: fruits2) // 不相交
        print(set3)
    }
}
