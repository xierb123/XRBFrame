//
//  FloatView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2022/3/23.
//

//  悬浮窗口视图组件

import UIKit

class FloatView: UIView {
    
    enum FloatPosition {
        case left
        case right
        case moving
    }
    
    //MARK: - 回调方法
    //var <#handle#>: (() -> Void)? = nil
    
    //MARK: - 全局变量
    // 最大拖动距离
    private var maxDistance: CGFloat = 100
    // 弹性系数
    private var viscosity: CGFloat = 0.1
    
    private var floatPosition: FloatPosition {
        get {
            return (position["x"] ?? 0) < parentView.width / 2 ? .left : .right
        }
    }
    
    private var position: [String: CGFloat] {
        get {
            return (UserDefaults.standard.object(forKey: "floatPosition") as? [String: CGFloat]) ?? ["x": self.x, "y": self.y]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "floatPosition")
            UserDefaults.standard.synchronize()
        }
    }
    
    private var smallCircleView: UIView!
    private var bigCircleRadius: CGFloat {
        self.width/2
    }
    private var smallCircleRadius: CGFloat = 0
    
    //MARK: - 懒加载
    private lazy var keyWindow: UIWindow = {
        if UIApplication.shared.keyWindow == nil {
            return ((UIApplication.shared.delegate?.window)!)!
        }else{
            return UIApplication.shared.keyWindow!
        }
    }()
    
    private lazy var parentView: UIView = {
        if let superView = self.superview {
            return superView
        }
        return keyWindow
    }()
    
    private lazy var shapeLayer: CAShapeLayer = {
        $0.fillColor = self.backgroundColor?.cgColor
        return $0
    }(CAShapeLayer())
    
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
        self.backgroundColor = .red
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:))))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        self.addGestureRecognizer(tapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapGesture(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)
        
        tapGesture.require(toFail: doubleTapGesture)
        
        self.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            guard let self = self else {return}
            self.smallCircleRadius = self.bigCircleRadius
            self.resetUI(position: self.floatPosition)
            self.setupSmallCircleView()
            self.setupShapeLayer()
        }
    }
    
    private func setupSmallCircleView() {
        smallCircleView = UIView()
        smallCircleView.backgroundColor = self.backgroundColor
        parentView.insertSubview(smallCircleView, belowSubview: self)
        
        resetSmallCircleView()
    }
    private func resetSmallCircleView() {
        self.smallCircleView.isHidden = false
        self.smallCircleView.center  = self.center
        self.smallCircleView.bounds = self.bounds
        self.smallCircleView.setCornerRadius(self.bigCircleRadius)
    }
    
    private func setupShapeLayer() {
        parentView.layer.insertSublayer(shapeLayer, below: self.layer)
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        
    }
}

//MARK: - 选择器事件(自定义方法)
extension FloatView {
    
    func resetMaxDistance(_ value: CGFloat) {
        self.maxDistance = value
    }
    
    // 获取到记录位置
    func getPosition() -> CGPoint {
        return CGPoint(x: position["x"] ?? self.x, y: position["y"] ?? self.y)
    }
    // 重置悬浮窗样式
    private func resetUI(position: FloatPosition) {
        self.setCornerRadius(0)
        switch position {
        case .left:    // 停靠在左侧
            self.roundCorners([.topRight, .bottomRight], radius: bigCircleRadius)
        case .right:   // 停靠在右侧
            self.roundCorners([.topLeft, .bottomLeft], radius: bigCircleRadius)
        case .moving:  // 移动中
            self.setCornerRadius(bigCircleRadius)
        }
    }
    
    // 悬浮窗贴边操作
    private func closeAnimation() {
        let positionX = self.centerX < parentView.width/2 ? 0 : parentView.width - self.width
        let positionY = min(max(self.centerY, Constant.navigationHeight), parentView.height - Constant.tabBarHeight*2)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.origin = CGPoint(x: positionX, y: positionY)
        } completion: { [weak self] finished in
            guard let self = self else {return}
            self.position = ["x": self.origin.x, "y": self.origin.y]
            self.resetUI(position: self.origin.x == 0 ? .left : .right)
            self.resetSmallCircleView()
        }
    }
    
    // 跟随手指滑动
    @objc
    private func panGesture(_ sender: UIPanGestureRecognizer) {
        resetUI(position: .moving)
        let translation = sender.translation(in: keyWindow)
        let center: CGPoint = self.center
        self.center = CGPoint(x: center.x+translation.x, y: center.y+translation.y)
        sender.setTranslation(.zero, in: keyWindow)
        
        // 计距离圆心的距离
        let distanceOfCenter = getDistance(between: self.center, and: smallCircleView.center)
        let smallCircleR = smallCircleRadius - distanceOfCenter / 10
        
        // 根据变化设置小圆的尺寸
        smallCircleView.bounds = CGRect(x: 0.0, y: 0.0, width: smallCircleR * 2, height: smallCircleR * 2)
        smallCircleView.setCornerRadius(smallCircleR)
        
        // 如果两圆心距离大于最大距离就移除
        if distanceOfCenter > maxDistance {
            smallCircleView.isHidden = true
            shapeLayer.removeFromSuperlayer()
        } else if distanceOfCenter > 0 && !smallCircleView.isHidden {
            // 开始拖动时,绘制形变路径
            shapeLayer.path = self.getPath(with: self, and: smallCircleView).cgPath
        }
        
        if sender.state == .began {
            setupShapeLayer()
        }
        if sender.state == .cancelled || sender.state == .ended { //滑动结束 或 滑动取消
            //TODO: - 此处应该进行贴边操作
            clearPath()
            resetSmallCircleAndShapeLayer(with: distanceOfCenter)
            //closeAnimation()
        }
    }
    
    @objc
    private func tapGesture(_ sender: UITapGestureRecognizer) {
        print("单击了")
    }
    
    @objc
    private func doubleTapGesture(_ sender: UITapGestureRecognizer) {
        print("双击了")
    }
}

//MARK: - 贝塞尔曲线 拖动变形
extension FloatView {
    // 计算圆点间距(勾股定理)
    private func getDistance(between bigCircleCenter: CGPoint, and smallCircleCenter: CGPoint) -> CGFloat {
        let distanceX = bigCircleCenter.x - smallCircleCenter.x
        let distanceY = bigCircleCenter.y - smallCircleCenter.y
        return sqrt(distanceX * distanceX + distanceY * distanceY)
    }
    
    // 手势结束后重置样式
    private func resetSmallCircleAndShapeLayer(with distanceOfCenter: CGFloat) {
        if distanceOfCenter > maxDistance { // 爆炸动效, 销毁
            let imageView = UIImageView(frame: self.bounds)
            var boomArr:[UIImage] = []
            for i in 1...8 {
                let image = UIImage(named: "boom_\(i)")!
                boomArr.append(image)
            }
            imageView.animationImages = boomArr
            imageView.animationDuration = 0.5
            imageView.animationRepeatCount = 1
            //imageView.startAnimating()
            //self.addSubview(imageView)
            DispatchQueue.main.async {
                //self.removeFromSuperview()
            }
            closeAnimation()
        } else {
            // 移除不规则矩形
            smallCircleView.isHidden = true
            
            // 还原位置
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: viscosity, initialSpringVelocity: 0, options: .curveLinear) {
                self.center = self.smallCircleView.center;
            } completion: { finished in
                self.resetUI(position: self.origin.x == 0 ? .left : .right)
                self.resetSmallCircleView()
            }
        }
    }
    
    // 清除不规则路径
    private func clearPath() {
        self.shapeLayer.path = CGPath(rect: .zero, transform: nil)
        self.shapeLayer.removeFromSuperlayer()
    }
    
    // 描绘两圆之间的不规则路径
    private func getPath(with bigCircle: UIView, and smallCircle: UIView) -> UIBezierPath {
        let bigCenter = bigCircle.center
        let x2 = bigCenter.x
        let y2 = bigCenter.y
        let r2 = bigCircle.width/2
        
        let smallCenter = smallCircle.center
        let x1 = smallCenter.x
        let y1 = smallCenter.y
        let r1 = smallCircle.width/2
        
        // 获取圆心距离
        let distanceOfCenter = getDistance(between: bigCenter, and: smallCenter)
        
        let sin = (x2 - x1) / distanceOfCenter
        let cos = (y2 - y1) / distanceOfCenter
        
        // 坐标系基于父控件
        let pointA = CGPoint(x: x1 - r1 * cos, y: y1 + r1 * sin)
        let pointB = CGPoint(x: x1 + r1 * cos, y: y1 - r1 * sin)
        let pointC = CGPoint(x: x2 + r2 * cos, y: y2 - r2 * sin)
        let pointD = CGPoint(x: x2 - r2 * cos, y: y2 + r2 * sin)
        
        let pointO = CGPoint(x: pointA.x + distanceOfCenter / 2 * sin, y: pointA.y + distanceOfCenter / 2 * cos)
        let pointP = CGPoint(x: pointB.x + distanceOfCenter / 2 * sin, y: pointB.y + distanceOfCenter / 2 * cos)
        
        let path = UIBezierPath()
        
        // 移动到点A
        path.move(to: pointA)
        // 绘制AB线段
        path.addLine(to: pointB)
        // 绘制BC曲线
        path.addQuadCurve(to: pointC, controlPoint: pointP)
        // 绘制cd线段
        path.addLine(to: pointD)
        // 绘制DA曲线
        path.addQuadCurve(to: pointA, controlPoint: pointO)
        
        return path
    }
}

