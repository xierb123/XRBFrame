//
//  PromptExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

extension UIView {
    private struct AssociatedKey {
        static var loadingView = "Prompt.LoadingView"
        static var networkExceptionView = "Prompt.NetworkExceptionView"
    }

    var loadingView: LoadingView? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKey.loadingView) as? LoadingView)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKey.loadingView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    var networkExceptionView: NetworkExceptionView? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKey.networkExceptionView) as? NetworkExceptionView)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKey.networkExceptionView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var isLoading: Bool {
        return loadingView?.superview != nil
    }
    
    var isNetworkException: Bool {
        return networkExceptionView?.superview != nil
    }
}

// MARK: Loading
extension UIView {
    func showLoading(style: LoadingViewStyle = .default,
                     layoutClosure: ((LoadingView) -> Void)? = nil) {

        DispatchQueue.main.safeAsync {
            if self.loadingView == nil {
                self.loadingView = LoadingView()
            }
            self.loadingView?.show(in: self, style: style, layoutClosure: layoutClosure)
        }
    }

    func hideLoading() {
        self.loadingView?.dismiss()
    }
}

// MARK: Network Exception
extension UIView {
    func showNetworkException(style: NetworkExceptionStyle = .exception,
                              theme: NetworkExceptionTheme = .light,
                              isScrollEnabled: Bool = false,
                              isShowBack: Bool = false,
                              layoutClosure: ((NetworkExceptionView) -> Void)? = nil,
                              reloadClosure: ReloadClosure? = nil,
                              backClosure: BackClosure? = nil) {

        DispatchQueue.main.safeAsync {
            if self.networkExceptionView == nil {
                self.networkExceptionView = NetworkExceptionView()
            }
            self.networkExceptionView?.show(in: self,
                                            style: style,
                                            theme: theme,
                                            isShowBack: isShowBack,
                                            isScrollEnabled: isScrollEnabled,
                                            layoutClosure: layoutClosure,
                                            reloadClosure: reloadClosure,
                                            backClosure: backClosure)
        }
    }

    func hideNetworkException() {
        self.networkExceptionView?.dismiss()
    }
}
