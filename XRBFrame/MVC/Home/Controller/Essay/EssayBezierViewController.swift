//
//  EssayBezierViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/10/26.
//
//  贝塞尔曲线绘制多边形页面

import UIKit

class EssayBezierViewController: BaseViewController {
    
    //MARK: - 全局变量
    
    //MARK: - 懒加载
    
    //MARK: - init/deinit方法
    required init(parameters: [String : Any]? = nil) {
        super.init(parameters: parameters)
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupBezierView()
    }
    
    private func setupBezierView() {
        let style = BezierStyle()
        style.keyPoints = [CGPoint(x: 100, y: 0),
                           CGPoint(x: 180, y: 20),
                           CGPoint(x: 200, y: 100),
                           CGPoint(x: 180, y: 180),
                           CGPoint(x: 100, y: 200),
                           CGPoint(x: 20, y: 180),
                           CGPoint(x: 0, y: 100),
                           CGPoint(x: 20, y: 20),
                           CGPoint(x: 100, y: 0)]
        
        let bezierView = BezierView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), style: style)
        self.view.addSubview(bezierView)
        
    }
}
