//
//  ModuleWKWebViewViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2022/5/27.
//
//  WKWebView


import UIKit
import WebKit

class ModuleWKWebViewViewController: BaseViewController {
    
    //MARK: - 全局变量
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    //MARK: - 设置UI
    private func setupView() {
        setupWebView()
        resetNavigationbar()
    }
    
    private func setupWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        //webView.uiDelegate = self
        load()
        self.view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // 在navigationBar上添加前进和刷新按钮
    private func resetNavigationbar() {
        let goForwardBtn: UIButton = {
            let button = UIButton()
            button.setTitle("前进", for: UIControl.State.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            button.addTarget(self, action: #selector(goForwardAction), for: UIControl.Event.touchUpInside)
            return button
        }()
        
        let reloadBtn: UIButton = {
            let button = UIButton()
            button.setTitle("刷新", for: UIControl.State.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            button.addTarget(self, action: #selector(reloadFromOrigin), for: UIControl.Event.touchUpInside)
            return button
        }()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: goForwardBtn), UIBarButtonItem(customView: reloadBtn)]
    }
    
    // 加载的不同方式
    private func load() {
        // 加载网页URL
        guard let url = URL(string: "https://www.baidu.com") else {return}
        webView.load(URLRequest(url: url))
        
        // 加载本地html文件
        //webView.loadHTMLString("<h1>张三最牛逼</h1>", baseURL: nil)
        
        // 加载文件，并指定 MIME 类型和编码类型
        //webView.load(<#T##data: Data##Data#>, mimeType: <#T##String#>, characterEncodingName: <#T##String#>, baseURL: <#T##URL#>)
        
        // 加载本地文件(适用于 iOS 9 及以上)
        //webView.loadFileURL(<#T##URL: URL##URL#>, allowingReadAccessTo: <#T##URL#>)
    }
    
    
}

extension ModuleWKWebViewViewController {
    override func clickBackBtn() {
        if webView.canGoBack {
            webView.goBack()
            return
        }
        super.clickBackBtn()
    }
    
    @objc
    private func goForwardAction() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc
    private func reloadAction() {
        webView.reload()
    }
    
    // 会比较网络数据变化，如果没有变化，则使用缓存，否则重新请求
    @objc
    private func reloadFromOrigin() {
        webView.reloadFromOrigin()
    }
}

extension ModuleWKWebViewViewController: WKNavigationDelegate, UIWebViewDelegate {
    
}
 
