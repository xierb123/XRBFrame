//
//  Obj.swift
//  HKRouter
//
//  Created by gaoyuan on 2020/1/14.
//  Copyright © 2020 gaoyuan. All rights reserved.
//

import UIKit
import URLNavigator


open class HKRouterConfig: NSObject {
    //router注册表plist文件名
    public static var routerPlistName = "PageRoute"
    //router自定义协议头
    public static var routerSchemesName = "navigator"
    //填充跳转的web类名
    public static var routerWebName = "TestViewController"
 

}

open class HKRouter :NSObject{
    public static var routerShared = Navigator()
    
    public static func open(_ url:String)  {
        
        if !HKRouter.routerShared.open(url) {
            if !(HKRouter.routerShared.push(url) != nil) {
            }
        }
    }
}
