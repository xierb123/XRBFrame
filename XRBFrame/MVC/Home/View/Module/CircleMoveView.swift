//
//  CircleMoveView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2022/3/25.
//

//  做圆周运动的视图组件

import UIKit

class CircleMoveView: UIView {
    
    //MARK: - 回调方法
    //var <#handle#>: (() -> Void)? = nil
    
    //MARK: - 全局变量
    
    //MARK: - 懒加载
    
    //MARK: - init/deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI布局
    private func setupView() {
        self.backgroundColor = .green
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            guard let self = self else {return}
            self.setCornerRadius(self.width/4)
            self.animationRotation()
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        
    }
}

//MARK: - 选择器事件(自定义方法)
extension CircleMoveView {
    
    // 获取运动轨迹
    private func animationRotation() {
        
        //MARK: - 添加自转动画
        let rotateTimeFunction = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)]
        
        var rotateValues = [NSNumber(value: 0)]
        let value = rotateValues.last!.floatValue + Float.pi * 2
        rotateValues.append(NSNumber(value: value))

        let rotateAnim = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotateAnim.keyTimes = [0.0, 1.0]
        rotateAnim.duration = 3
        rotateAnim.repeatCount = HUGE;
        rotateAnim.isRemovedOnCompletion = false;
        //rotateAnim.fillMode = CAMediaTimingFillMode.forwards;
        rotateAnim.values = rotateValues
        rotateAnim.timingFunctions = rotateTimeFunction
        
        self.layer.add(rotateAnim, forKey: "rotate")
        
        //MARK: - 添加公转动画
        
        let centerX = self.superview!.centerX
        let boundingRect = CGRect(x:centerX-75, y:50, width:150, height:150)
        let orbit = CAKeyframeAnimation(keyPath:"position")
        orbit.duration = 3
        orbit.repeatCount = HUGE;
        orbit.path = CGPath(ellipseIn: boundingRect, transform: nil)
        orbit.calculationMode = CAAnimationCalculationMode.paced
         
        self.layer.add(orbit, forKey:"Move")
        
        //MARK: - 添加运动轨迹
        
        let pathLayer = CAShapeLayer()
        pathLayer.frame = self.superview!.bounds
        //pathLayer.isGeometryFlipped = true
        pathLayer.path = orbit.path
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 1
        pathLayer.strokeColor = UIColor.black.cgColor
        
        //给运动轨迹添加动画
        let pathAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
        pathAnimation.duration = 3
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        //pathAnimation.delegate = (window as! CAAnimationDelegate)
        pathLayer.add(pathAnimation , forKey: "strokeEnd")
        
        self.superview!.layer.addSublayer(pathLayer)
    }
}

