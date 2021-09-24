//
//  TabBarConfig.swift
//  HiconTV
//
//  Created by devchena on 2020/2/29.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import ESTabBarController_swift

protocol TabBarComponentProtocol {
    func tabBarComponentOpened(_ parameters: [String: Any]?)
}

protocol TabBarItemContent {
    var title: String? { get }
    var image: UIImage? { get }
    var selectedImage: UIImage? { get }
    var contentView: ESTabBarItemContentView  { get }
    var viewController: UIViewController { get }
    var classType: BaseViewController.Type { get }
}

enum TabBarItemType: Int {
    case home
    case live
    case send
    case find
    case user
}

extension TabBarItemType: TabBarItemContent {
    var title: String? {
        switch self {
        case .home:
            return "首页"
        case .live:
            return "直播"
        case .send:
            return ""
        case .find:
            return "发现"
        case .user:
            return "我的"
        }
    }
        
    var image: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "ic_tabbar_home")
        case .live:
            return UIImage(named: "ic_tabbar_live")
        case .send:
            return UIImage(named: "ic_tabbar_remotecontrol_irregularity")
        case .find:
            return UIImage(named: "ic_tabbar_mall")
        case .user:
            return UIImage(named: "ic_tabbar_personal")
        }
    }

    var selectedImage: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "ic_tabbar_home_selected")
        case .live:
            return UIImage(named: "ic_tabbar_live_selected")
        case .send:
            return UIImage(named: "ic_tabbar_remotecontrol_irregularity")
        case .find:
            return UIImage(named: "ic_tabbar_mall_selected")
        case .user:
            return UIImage(named: "ic_tabbar_personal_selected")
        }
    }
    
    var contentView: ESTabBarItemContentView {
        let contentView: ESTabBarItemContentView
        switch self {
        case .home:
            contentView = ExampleBouncesContentView()
        case .live:
            contentView = ExampleBouncesContentView()
        case .send:
            contentView = TabBarItemBaseContentView()
        case .find:
            contentView = ExampleBouncesContentView()
        case .user:
            contentView = ExampleBouncesContentView()
        }
        
        contentView.renderingMode = .alwaysOriginal
        contentView.itemContentMode = .alwaysOriginal
        return contentView
    }
    
    var viewController: UIViewController {
        switch self {
        case .home:
            return HomeViewController()
        case .live:
            return LiveViewController()
        case .send:
            return SendViewController()
        case .find:
            return FindViewController()
        case .user:
            return UserViewController()
        }
    }
    
    var classType: BaseViewController.Type {
        switch self {
        case .home:
            return HomeViewController.self
        case .live:
            return LiveViewController.self
        case .send:
            return SendViewController.self
        case .find:
            return FindViewController.self
        case .user:
            return UserViewController.self
        }
    }
}
