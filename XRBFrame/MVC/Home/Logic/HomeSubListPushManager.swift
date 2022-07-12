//
//  HomeSubListPushManager.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/24.
//
//  首页子页面跳转控制器

import Foundation
import UIKit

enum Category{
    case code
    case module
    case audioAndVideo
    case animation
    case designMode
    case essay
    
    func getCategory() -> [String] {
        switch self {
        case .code :
            return [
                "Switch语句",
                "循环",
                "可空类型",
                "数组",
                "字典",
                "集合",
                "函数",
                "闭包",
                "枚举",
                "结构体和类",
                "属性",
                "初始化",
                "协议",
                "错误处理",
                "扩展",
                "泛型",
                "协议扩展",
                "内存分配",
                "Equatable&Comparable",
                "UserDefaults扩展",
                "元类型",
                "KVO",
                "线程 - GCD",
                "函数式编程"
            ]
        case .module:
            return [
                "自定义验证码输入框",
                "多样化列表",
                "可以展开收起的文本展示组件",
                "悬浮窗口",
                "WKWebView"
            ]
        case .audioAndVideo:
            return [
                "视频播放器封装"
            ]
        case .animation:
            return [
                "Present转场动画",
                "列表侧滑展示"
            ]
        case .designMode:
            return [
                "责任链模式",
                "策略模式",
                "命令模式",
                "中介者模式",
                "模式综合测试页面",
            ]
        case .essay:
            return [
                "华容道",
                "组件化",
                "爱宠collectionView列表绑定",
                "页面路由",
                "卡片样式展示",
                "贝塞尔曲线绘制多边形",
                "FloatingPanel",
                "快递问题"
            ]
        }
    }
}

struct HomeSubListPushManager {
    static weak var targetVC: BaseViewController?
    
    /// 通过分类和点击的索引值,判断跳转事件
    static func pushVC(with target:BaseViewController?, type: Category, indexPath: IndexPath) {
        targetVC = target
        switch type {
        case .code:
            // 代码学习
            pushCodeSubVC(with: indexPath)
        case .module:
            // 组件封装
            pushModuleSubVC(with: indexPath)
        case .audioAndVideo:
            // 音视频
            pushAudioAndVideoSubVC(with: indexPath)
        case .animation:
            // 动画效果
            pushAnimationSubVC(with: indexPath)
        case .designMode:
            // 设计模式
            pushDesignModeSubVC(with: indexPath)
        case .essay:
            // 随笔
            pushEssaySubVC(with: indexPath)
        }
    }
    
    static func pushCodeSubVC(with indexPath: IndexPath) {
        var vc: BaseViewController!
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            vc = CodeSwitchViewController()
        case (0, 1):
            vc = CodeLoopViewController()
        case (0, 2):
            vc = CodeOptionalViewController()
        case (0, 3):
            vc = CodeArrayViewController()
        case (0, 4):
            vc = CodeDictionaryViewController()
        case (0, 5):
            vc = CodeSetViewController()
        case(0, 6):
            vc = CodeFunctionViewController()
        case(0, 7):
            vc = CodeBlockViewController()
        case(0, 8):
            vc = CodeEnumViewController()
        case(0, 9):
            vc = CodeStructAndClassViewController()
        case(0, 10):
            vc = CodePropertyViewController()
        case(0, 11):
            vc = CodeInitViewController()
        case(0, 12):
            vc = CodeProtocolViewController()
        case(0, 13):
            vc = CodeErrorViewController()
        case(0, 14):
            vc = CodeExtensionViewController()
        case(0, 15):
            vc = CodeGenericsViewController()
        case(0, 16):
            vc = CodeExtensionProtocolViewController()
        case(0, 17):
            vc = CodeARCViewController()
        case(0, 18):
            vc = CodeEquatable_ComparableViewController()
        case(0, 19):
            vc = CodeUserDefaultsViewController()
        case(0, 20):
            vc = CodeMeatdataViewController()
        case(0, 21):
            vc = CodeKVOViewController()
        case(0, 22):
            vc = CodeGCDViewController()
        case(0, 23):
            vc = CodeFunctionalProgrammingViewController()
        default:
            return
        }
        Self.resetPushAction(vc, Category.code.getCategory()[indexPath.row])
    }
    static func pushModuleSubVC(with indexPath: IndexPath) {
        var vc: BaseViewController!
        switch (indexPath.section, indexPath.row) {
        case(0, 0):
            vc = ModuleVerificationCodeViewController()
        case(0, 1):
            vc = ModuleMutableTableViewController()
        case(0, 2):
            vc = ModuleLabelWithOpenViewController()
        case(0, 3):
            vc = ModuleFloatViewViewController()
        case(0, 4):
            vc = ModuleWKWebViewViewController()
        default:
            return
        }
        Self.resetPushAction(vc, Category.module.getCategory()[indexPath.row])
    }
    static func pushAudioAndVideoSubVC(with indexPath: IndexPath) {
        var vc: BaseViewController!
        switch (indexPath.section, indexPath.row) {
        case(0, 0):
            vc = VideoPlayerViewController()
        default:
            return
        }
        Self.resetPushAction(vc, Category.audioAndVideo.getCategory()[indexPath.row])
    }
    static func pushAnimationSubVC(with indexPath: IndexPath) {
        var vc: BaseViewController!
        switch (indexPath.section, indexPath.row) {
        case(0, 0):
            vc = AnimationForPresentViewController()
        case(0, 1):
            vc = AnimationSideSlipViewController()
        default:
            return
        }
        Self.resetPushAction(vc, Category.animation.getCategory()[indexPath.row])
    }
    static func pushDesignModeSubVC(with indexPath: IndexPath) {
        var vc: BaseViewController!
        switch (indexPath.section, indexPath.row) {
        case(0, 0):
            vc = DesignModeChainOfResponsibilityPatternViewController()
        case(0, 1):
            vc = DesignModeStrategyViewController()
        case(0, 2):
            vc = DesignModeCommandViewController()
        case(0, 3):
            vc = DesignModeMediatorViewController()
        case(0, 4):
            vc = DesignModeDemoViewController()
        default:
            return
        }
        Self.resetPushAction(vc, Category.designMode.getCategory()[indexPath.row])
    }
    static func pushEssaySubVC(with indexPath: IndexPath) {
        var vc: BaseViewController!
        switch (indexPath.section, indexPath.row) {
        case(0, 0):
            vc = EssayKlotskiViewController()
        case(0, 1):
            vc = EssayModularizationViewController()
        case(0, 2):
            vc = EssayCollectionViewController()
        case(0, 3):
            vc = EssayRouterViewController()
        case(0, 4):
            vc = EssayCardViewController()
        case(0, 5):
            vc = EssayBezierViewController()
        case(0, 6):
            vc = EssayFloatingPanelViewController()
        case(0, 7):
            vc = EssayExpressViewController()
        default:
            return
        }
        Self.resetPushAction(vc, Category.essay.getCategory()[indexPath.row])
    }
    
    static func resetPushAction(_ vc: BaseViewController, _ title: String) {
        vc.view.backgroundColor = .white
        vc.title = title
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_custom_back"), style: .plain, target: vc, action: #selector(vc.clickBackBtn))
        targetVC?.navigationController?.navigationBar.tintColor = UIColor.darkGray
        targetVC?.pushVC(vc)
    }
}
