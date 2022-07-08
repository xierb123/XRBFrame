//
//  ModuleFloatViewViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2022/3/23.
//

import UIKit

class ModuleFloatViewViewController: BaseViewController {
    
    //线条形状
    var lineType:CGLineCap!
    //线条粗细
    var lineWidth: CGFloat!
    //保存上一次停留的位置
    var lastPoint: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let redBall = FloatView()
        redBall.frame = CGRect(x: 10, y: 200, width: 50, height: 50)
        redBall.origin = redBall.getPosition()
        redBall.resetMaxDistance(100)
        self.view.addSubview(redBall)
        
        let circleBall = CircleMoveView()
        circleBall.frame = CGRect(x: Constant.screenWidth/2, y: Constant.screenHeight/2, width: 30, height: 30)
        self.view.addSubview(circleBall)
    }
}


//MARK: - 刮刮乐
extension ModuleFloatViewViewController {
    //触摸开始
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //多点触摸只考虑第一点
        guard  let touch = touches.first else {
            return
        }
        //保存当前点坐标
        lastPoint = touch.location(in: self.view)
        
    }
    
    //滑动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //多点触摸只考虑第一点
        guard  let touch = touches.first, let point = lastPoint else {
            return
        }
        
        //获取最新触摸点坐标
        let newPoint = touch.location(in: self.view)
        //清除两点间的涂层
        eraseMask(fromPoint: point, toPoint: newPoint)
        //保存最新触摸点坐标，供下次使用
        lastPoint = newPoint
    }
    
    
    //两点间的连线
    func eraseMask(fromPoint: CGPoint, toPoint: CGPoint) {
        //根据size大小创建一个基于位图的图形上下文
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, UIScreen.main.scale)
        
        //先将图片绘制到上下文中
        //image?.draw(in: self.bounds)
        
        //再绘制线条
        let path = UIBezierPath()
        path.move(to: fromPoint)
        path.addLine(to: toPoint)
        
        let pathLayer = CAShapeLayer()
        pathLayer.path = path.cgPath
        pathLayer.lineWidth = 1
        pathLayer.strokeColor = UIColor.black.cgColor
        
        
        self.view.layer.addSublayer(pathLayer)
    }
    
    
}
