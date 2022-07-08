//
//  BezierView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/10/27.
//
//  自定义绘制图形视图组件

import UIKit

public class BezierStyle {
    
    /// 关键点
    public var keyPoints: [CGPoint] = []
    /// 边线颜色
    public var strokeColor: UIColor = .red
    /// 填充颜色
    public var fillColor: UIColor = .white
    /// 边线宽度
    public var sideWidth: CGFloat = 30.0
    /// 线条拐角样式
    public var lineCapStyle: CGLineCap = .butt
    /// 终点样式
    public var lineJoinStyle: CGLineJoin = .round

    public init() {}
}


class BezierView: UIView {
    
    
    //MARK: - 回调方法
    //var <#handle#>: (() -> Void)? = nil
    
    //MARK: - 全局变量
    var bezierStyle: BezierStyle!
    /// 确定起始点
    var isStart: Bool = true
    
    //MARK: - 懒加载
    
    //MARK: - init/deinit
    init(frame: CGRect, style: BezierStyle) {
        super.init(frame: frame)
        
        bezierStyle = style
        setupView()
    }
    
    /*init(<#parameter#>: <#Object#>) {
     super.init(frame: .zero)
     
     setupView()
     }*/
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI布局
    private func setupView() {
        self.backgroundColor = .green
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setView()
    }
    
    func setView() {
        guard bezierStyle.keyPoints.count > 2 else {
            printLog("绘制失败")
            return
        }
        
        func getMid(_ point1: CGPoint, _ point2: CGPoint) -> CGPoint {
            return CGPoint(x: (point1.x + point2.x)/2, y: (point1.y + point2.y)/2)
        }
        
        let bezierPath = UIBezierPath()
        bezierPath.lineWidth = bezierStyle.sideWidth
        bezierPath.lineCapStyle = .round
        bezierPath.lineJoinStyle = .round
        bezierStyle.strokeColor.setStroke()
        bezierStyle.fillColor.setFill()
        
        var prevPoint: CGPoint!
        for index in 0..<bezierStyle.keyPoints.count {
            let currPoint = bezierStyle.keyPoints[index]
            
            if index == 0 {
                bezierPath.move(to: currPoint)
            } else {
//                let lastPoint = bezierStyle.keyPoints[index-1]
//                let nextPoint = bezierStyle.keyPoints[index == bezierStyle.keyPoints.count-1 ? 0 : index + 1]
//                let p0 = getMid(lastPoint, currPoint)
//                let p1 = getMid(currPoint, nextPoint)
//                if index % 2 == 1 {
//                    bezierPath.addQuadCurve(to: nextPoint, controlPoint: currPoint)
//                }
                
                bezierPath.addLine(to: currPoint)
                
            }
        }
//        bezierPath.close()
        bezierPath.stroke()
        bezierPath.fill()
        
        
        
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        
    }
}

//MARK: - 选择器事件(自定义方法)
extension BezierView {
    
}

