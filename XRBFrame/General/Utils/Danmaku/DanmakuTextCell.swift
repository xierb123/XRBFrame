//
//  DanmakuTextCell.swift
//  DanmakuKit_Example
//
//  Created by Q YiZhong on 2020/8/29.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import DanmakuKit

class DanmakuTextCell: DanmakuCell {

    required init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.contentsScale = UIScreen.main.scale
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willDisplay() {
        self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: 24)
        backgroundColor = UIColor(hexString: "#000000", alpha: 0.2)
        self.setCornerRadius(12, masksToBounds: true)
        layer.contentsScale = UIScreen.main.scale
    }
    
    override func displaying(_ context: CGContext, _ size: CGSize, _ isCancelled: Bool) {
        guard let model = model as? DanmakuTextCellModel else { return }
        let text = NSString(string: model.text)
        context.setLineWidth(0.5)
        context.setLineJoin(.round)
        context.setStrokeColor(UIColor.white.cgColor)
        context.saveGState()
        context.setTextDrawingMode(.stroke)
        
        
        let attributes: [NSAttributedString.Key: Any] = [.font: model.font, .foregroundColor: model.isSystem ? UIColor(hexString: "#00FFA4") : UIColor.white]
        //text.draw(at: .zero, withAttributes: attributes)
        context.restoreGState()
        
        context.setTextDrawingMode(.fill)
        let systemImage = UIImage(named: "ic_danmu_system")
        if model.isSystem {
            systemImage?.draw(in: CGRect(x: 8, y: 2, width: 20, height: 20))
            text.draw(at: CGPoint(x: 32, y: 3), withAttributes: attributes)
        } else {
            text.draw(at: CGPoint(x: 28, y: 3), withAttributes: attributes)
            
            let rectForHeaderImg = CGRect(x: 0, y: 0, width: 24, height: 24)
            context.addEllipse(in: rectForHeaderImg)
            context.clip()
            model.userImg.draw(in: rectForHeaderImg)
        }
    }
    
    override func didDisplay(_ finished: Bool) {
        
    }
    
}
