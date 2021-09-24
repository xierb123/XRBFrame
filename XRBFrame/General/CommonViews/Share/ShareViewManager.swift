//
//  ShareViewManager.swift
//  HiconMultiScreen
//
//  Created by devchena on 2020/11/26.
//

import UIKit

typealias ShareSelectHandler = (ShareType) -> Void

extension ShareView {
    class func show(style: ShareStyle = .default, selectHandler: @escaping ShareSelectHandler) {
        DispatchQueue.main.async {
            guard let keyWindow = UIApplication.shared.keyWindow else {
                return
            }
            
            let shareView = ShareView(style: style)
            shareView.selectHandler = selectHandler
            shareView.show(in: keyWindow)
        }
    }
}
