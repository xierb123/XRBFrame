//
//  EventRouter.swift
//  QingkMediaConvergence_Swift
//
//  Created by gaoyuan on 2019/8/15.
//  Copyright © 2019 Qingk. All rights reserved.
//

import Foundation
public protocol EventRouter {
    func routerEvent(_ event: RouterEvent?)
}

extension UIResponder: EventRouter {
    
    @objc open func routerEvent(_ event: RouterEvent?) {
        self.next?.routerEvent(event)
    }
    
}
