//
//  NavigationMap.swift
//  URLNavigatorExample
//
//  Created by Suyeol Jeon on 7/12/16.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import SafariServices
import UIKit

import URLNavigator

public protocol RouterController {
    func initRouterParams(params : Dictionary<String , String>)
}

public enum HKRouterMap {
    public static func initializeRouter(navigator: NavigatorType) {
        
        navigator.register("http://<path:_>", self.webViewControllerFactory)
        navigator.register("https://<path:_>", self.webViewControllerFactory)
        
        navigator.handle("\(HKRouterConfig.routerSchemesName)://alert", self.alert(navigator: navigator))
        if let bundlePath = Bundle.main.path(forResource: HKRouterConfig.routerPlistName, ofType: "plist") {
            let bundleDic = NSMutableDictionary(contentsOfFile: bundlePath)
            for key in bundleDic!.allKeys {
                if let clsName : NSString = bundleDic!.object(forKey: key) as? NSString {
                    if key is NSString {
                        if let cls = NSClassFromString("\(clsName)") {
                            self.viewControllerFactory(classStr: cls,navigator: navigator,routerName: key as! NSString)
                        }
                        else if let appName: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String?,let cls = NSClassFromString("\(appName ?? "").\(clsName)")  {
                            self.viewControllerFactory(classStr: cls,navigator: navigator,routerName: key as! NSString)
                        }
                    }
                }
            }
        }
    }
    //按plist表注册router页面对象
    private static func viewControllerFactory(
        classStr: AnyClass,
        navigator:NavigatorType,
        routerName: NSString
    )  {
        if classStr.isSubclass(of: UIViewController.self) {
            navigator.register("\(HKRouterConfig.routerSchemesName)://\(routerName)") { url, values, context in
                //FIXME: - 此处vcType的类型应该是UIViewController,但是因为项目的公共页面为BaseViewCOntroller,且BaseViewController改变了默认的初始化方法,因此将类型置为BaseViewCOntroller
                if let vcType = classStr as? BaseViewController.Type {
                    let vc = vcType.init()
                    if let routerVc = vc as? RouterController {
                        routerVc.initRouterParams(params: url.queryParameters)
                        return vc
                    }
                }
                return nil
            }
        }
    }
    
    
    private static func webViewControllerFactory(
        url: URLConvertible,
        values: [String: Any],
        context: Any?
    ) -> UIViewController? {
        guard let url = url.urlValue else { return nil }
        //处理注册表中web链接
        if let bundlePath = Bundle.main.path(forResource: HKRouterConfig.routerPlistName, ofType: "plist") {
            let bundleDic = NSMutableDictionary(contentsOfFile: bundlePath)
            for key in bundleDic!.allKeys {
                if let clsName : NSString = bundleDic!.object(forKey: key) as? NSString {
                    if key is NSString {
                        let name = key as! String
                        if !name.isEmpty && url.urlStringValue.contains(name),name.hasPrefix("http") {
                            var className:AnyClass?
                            if let cls = NSClassFromString("\(clsName)") {
                                className = cls
                            }
                            else if let appName: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String?,let cls = NSClassFromString("\(appName ?? "").\(clsName)")  {
                                className = cls
                            }
                            if let cln = className , cln.isSubclass(of: UIViewController.self) {
                                if let vcType = cln as? UIViewController.Type {
                                    let vc = vcType.init()
                                    if let routerVc = vc as? RouterController {
                                        routerVc.initRouterParams(params: url.queryParameters)
                                        return vc
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        //处理未注册寻常web页面，前提是有在config注册通用web类
        if !url.urlStringValue.isEmpty {
            var className:AnyClass?
            if let cls = NSClassFromString("\(HKRouterConfig.routerWebName)") {
                className = cls
            }
            else if let appName: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String?,let cls = NSClassFromString("\(appName ?? "").\(HKRouterConfig.routerWebName)")  {
                className = cls
            }
            if let cln = className , cln.isSubclass(of: UIViewController.self) {
                if let vcType = cln as? UIViewController.Type {
                    let vc = vcType.init()
                    if let routerVc = vc as? RouterController {
                        routerVc.initRouterParams(params: ["url":url.urlStringValue])
                        return vc
                    }
                }
            }
        }
        
        return nil
    }
    
    
    
    private static func alert(navigator: NavigatorType) -> URLOpenHandlerFactory {
        return { url, values, context in
            guard let title = url.queryParameters["title"] else { return false }
            let message = url.queryParameters["message"]
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            navigator.present(alertController)
            return true
        }
    }
}
