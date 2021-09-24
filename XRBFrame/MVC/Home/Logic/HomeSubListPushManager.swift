//
//  HomeSubListPushManager.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/24.
//
//  首页子页面跳转控制器

import Foundation

struct HomeSubListPushManager {
    static weak var targetVC: BaseViewController?
    
    static var code: [String] {
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
            "Equatable&Comparable"
        ]
    }
    
    static var module: [String] {
        return [
            "自定义验证码输入框",
            "多样化列表"
        ]
    }
    
    static var audioAndVideo: [String] {
        return [
            "视频播放器封装"
        ]
    }
    
    static var animation: [String] {
        return [
            "赵六"
        ]
    }
    
    static var essay: [String] {
        return [
            "华容道",
            "组件化"
        ]
    }
    
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
        default:
            return
        }
        vc.view.backgroundColor = .white
        vc.title = code[indexPath.row]
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_custom_back"), style: .plain, target: vc, action: #selector(vc.clickBackBtn))
        targetVC?.navigationController?.navigationBar.tintColor = UIColor.darkGray
        targetVC?.pushVC(vc)
    }
    static func pushModuleSubVC(with indexPath: IndexPath) {
        var vc: BaseViewController!
        switch (indexPath.section, indexPath.row) {
        case(0, 0):
            vc = ModuleVerificationCodeViewController()
        case(0, 1):
            vc = ModuleMutableTableViewController()
        default:
            return
        }
        vc.view.backgroundColor = .white
        vc.title = module[indexPath.row]
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_custom_back"), style: .plain, target: vc, action: #selector(vc.clickBackBtn))
        targetVC?.navigationController?.navigationBar.tintColor = UIColor.darkGray
        targetVC?.pushVC(vc)
    }
    static func pushAudioAndVideoSubVC(with indexPath: IndexPath) {
        var vc: BaseViewController!
        switch (indexPath.section, indexPath.row) {
        case(0, 0):
            vc = VideoPlayerViewController()
        default:
            return
        }
        vc.view.backgroundColor = .white
        vc.title = audioAndVideo[indexPath.row]
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_custom_back"), style: .plain, target: vc, action: #selector(vc.clickBackBtn))
        targetVC?.navigationController?.navigationBar.tintColor = UIColor.darkGray
        targetVC?.pushVC(vc)
    }
    static func pushAnimationSubVC(with indexPath: IndexPath) {
        
    }
    static func pushEssaySubVC(with indexPath: IndexPath) {
        var vc: BaseViewController!
        switch (indexPath.section, indexPath.row) {
        case(0, 0):
            vc = EssayKlotskiViewController()
        case(0, 1):
            vc = EssayModularizationViewController()
        default:
            return
        }
        vc.view.backgroundColor = .white
        vc.title = essay[indexPath.row]
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_custom_back"), style: .plain, target: vc, action: #selector(vc.clickBackBtn))
        targetVC?.navigationController?.navigationBar.tintColor = UIColor.darkGray
        targetVC?.pushVC(vc)
    }
}
