//
//  KlotskiImageView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/13.
//

import UIKit

class KlotskiImageView: UIImageView {
    
    var moveHandle: ((_ currentIndex: Int, _ targetIndex: Int) -> ())? = nil
    
    /// 边界方向
    enum GameBorder {
        case unknown
        case top
        case left
        case bottom
        case right
    }
    /// 边界方向
    enum SwippeDirection {
        case up
        case left
        case down
        case right
    }
    
    /// 初始化的序列值
    var initIndex: Int = 0 {
        didSet {
            let label = UILabel()
            label.textAlignment = .center
            label.text = "\(initIndex)"
            label.textColor = .red
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            self.addSubview(label)
            label.snp.makeConstraints { (make) in
                // 自动布局
                make.center.equalToSuperview()
            }
        }
    }
    /// 当前的序列值
    var moveIndex: Int = 0 {
        didSet {
            borderArray.removeAll()
            if [0, 1, 2].contains(moveIndex) {
                borderArray.append(.top)
            }
            if [0, 3, 6].contains(moveIndex) {
                borderArray.append(.left)
            }
            if [6, 7, 8].contains(moveIndex) {
                borderArray.append(.bottom)
            }
            if [2, 5, 8].contains(moveIndex) {
                borderArray.append(.right)
            }
        }
        
    }
    /// 边界位置数组
    var borderArray: [GameBorder] = []
    
    func addSwipeGestureRecognizer() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        upSwipe.direction = .up
        self.addGestureRecognizer(upSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        leftSwipe.direction = .left
        self.addGestureRecognizer(leftSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        downSwipe.direction = .down
        self.addGestureRecognizer(downSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        rightSwipe.direction = .right
        self.addGestureRecognizer(rightSwipe)
    }
    
    func setUserInteraction(enable: Bool) {
        self.isUserInteractionEnabled = enable
    }
    
    @objc private func swipeAction(_ swipe: UISwipeGestureRecognizer) {
        
        let currentIndex = (swipe.view as! KlotskiImageView).moveIndex
        var targetIndex = 0
        var direction: SwippeDirection!
        switch swipe.direction.rawValue {
        case 1:
            direction = .right  // 右滑
            targetIndex = currentIndex + 1
        case 2:
            direction = .left   // 左滑
            targetIndex = currentIndex - 1
        case 4:
            direction = .up     // 上滑
            targetIndex = currentIndex - 3
        case 8:
            direction = .down   // 下滑
            targetIndex = currentIndex + 3
        default:
            break
        }
        
        if  borderArray.contains(.left) && direction == .left ||
                borderArray.contains(.right) && direction == .right ||
                borderArray.contains(.top) && direction == .up ||
                borderArray.contains(.bottom) && direction == .down {
            return
        }
        
        moveHandle?(currentIndex, targetIndex)
    }
}

/*
 
 var direction: SwippeDirection!
 switch swipe.direction.rawValue {
 case 1:
 direction = .right  // 右滑
 case 2:
 direction = .left   // 左滑
 case 4:
 direction = .up     // 上滑
 case 8:
 direction = .down   // 下滑
 default:
 break
 }
 
 */
