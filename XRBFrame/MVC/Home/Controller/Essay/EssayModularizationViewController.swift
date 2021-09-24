//
//  EssayModularizationViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/18.
//
//  组件化

import UIKit
import XRBModule

class EssayModularizationViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    // 此处是直接都调用组件,具体的组件封装地址如下
    // https://juejin.cn/post/6844903587869360135

    private func setupView() {
        let redBall = RedBall(frame: CGRect(x: Constant.screenWidth/2-40, y: Constant.screenHeight/2-40, width: 80, height: 80))
        self.view.addSubview(redBall)
    }

}
