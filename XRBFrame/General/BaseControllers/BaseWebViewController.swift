//
//  BaseWebViewController.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import WebKit

protocol WKWebViewContentProtocol {
    func webView(_ webView: WKWebView, didChange title: String?)
}

class BaseWebViewController: BaseViewController {
    var currentURL: URL? {
        return webView.url
    }
    
    /// 背景色
    var backgroundColor: UIColor = UIColor.white {
        didSet {
            view.backgroundColor = backgroundColor
            webView.backgroundColor = backgroundColor
            webView.scrollView.backgroundColor = backgroundColor
        }
    }
    
    /// 是否可滚动反弹
    var scrollBounces: Bool = true {
        didSet {
            webView.scrollView.bounces = scrollBounces
        }
    }

    private var requestURL: URL?

    private(set) var webView: WKWebView!

    private(set) lazy var progressView: UIProgressView = {
        let height: CGFloat = 2.0 / UIScreen.main.scale
        let navigationBarSize: CGSize = navigationController?.navigationBar.bounds.size ?? .zero
        let y = navigationBarSize.height - height
        let frame = CGRect(x: 0.0, y: y, width: navigationBarSize.width, height: height)
        let progressView = UIProgressView(frame: frame)
        progressView.tintColor = Color.theme
        progressView.trackTintColor = UIColor.clear
        return progressView
    }()

    required init(parameters: [String : Any]? = nil) {
        super.init(parameters: parameters)
        
        if let url = parameters?["url"] as? String {
            requestURL = URL(string: url)
        }
        if let title = parameters?["title"] as? String {
            navigationItem.title = title
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        removeAllObservers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        addObservers()

        if let url = requestURL {
            loadURL(url)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !isNavigationBarHidden {
            navigationController?.navigationBar.addSubview(progressView)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if !isNavigationBarHidden {
            progressView.removeFromSuperview()
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if progressView.superview != nil {
                let progress = CGFloat(webView.estimatedProgress)
                print("estimatedProgress: \(progress)")

                progressView.alpha = 1.0 - progress
                progressView.setProgress(Float(webView.estimatedProgress), animated: true)
                if progress >= 1.0 {
                    progressView.alpha = 0.0
                    progressView.setProgress(0.0, animated: false)
                }
            }
        }

        if keyPath == "title" {
            print("title: \(String(describing: webView.title))")
            (self as? WKWebViewContentProtocol)?.webView(webView, didChange: webView.title)
        }
    }

    private func setupView() {
        view.backgroundColor = backgroundColor

        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = false

        let userContentController = WKUserContentController()
        // 通过js注入用户信息组成的cookie
        if let cookieSource = CookieManager.cookieSource(for: .script) {
            let cookieScript = WKUserScript(source: cookieSource, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            userContentController.addUserScript(cookieScript)
        }

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = userContentController

        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.backgroundColor = backgroundColor
        webView.scrollView.backgroundColor = backgroundColor
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.showsVerticalScrollIndicator = true
        webView.scrollView.showsHorizontalScrollIndicator = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view.addSubview(webView)

        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func addObservers() {
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: .loginSuccessful, object: nil)
    }

    private func removeAllObservers() {
        webView.removeObserver(self, forKeyPath: "title")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        NotificationCenter.default.removeObserver(self)
    }
}

extension BaseWebViewController {
    func loadURL(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func loadURLWithCookie(_ url: URL) {
        var request = URLRequest(url: url)
        if let value = CookieManager.cookieSource(for: .request) {
            request.addValue(value, forHTTPHeaderField: "Cookie")
        }
        webView.load(request)
    }

    func loadHTMLString(_ html: String, baseURL: URL? = nil) {
        webView.loadHTMLString(html, baseURL: baseURL)
    }

    func evaluateJavaScript(_ javaScriptString: String, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        webView.evaluateJavaScript(javaScriptString, completionHandler: completionHandler)
    }

    func webViewGoBack() {
        webView.goBack()
    }

    func webViewCanGoBack() -> Bool {
        return webView.canGoBack
    }

    func webViewReload() {
        webView.reload()
    }

    /// 添加js交互
    func addScriptMessageHandlers(_ scriptMessageHandler: WKScriptMessageHandler, forNames names: [String]) {
        let userContentController = webView.configuration.userContentController
        names.forEach { [weak scriptMessageHandler] (name) in
            guard let handler = scriptMessageHandler else { return }
            userContentController.add(handler, name: name)
        }
    }

    /// 移除js交互
    func removeAllScriptMessageHandlers(forNames names: [String]) {
        let userContentController = webView.configuration.userContentController
        names.forEach { (name) in
            userContentController.removeScriptMessageHandler(forName: name)
        }
    }
}

extension BaseWebViewController {
    @objc private func loginSuccess() {
        if let cookieSource = CookieManager.cookieSource(for: .script) {
            let cookieScript = WKUserScript(source: cookieSource, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            webView.configuration.userContentController.removeAllUserScripts()
            webView.configuration.userContentController.addUserScript(cookieScript)

            // 重新加载并注入用户信息cookie
            if let url = webView.url {
                loadURLWithCookie(url)
            }
        }
    }
}

extension BaseWebViewController: WKNavigationDelegate {
    /// 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let requestURL = navigationAction.request.url {
            if let requestURLString = requestURL.absoluteString.removingPercentEncoding {
                if requestURLString.hasPrefix("tel://") || requestURLString.hasPrefix("mailto://") || requestURLString.hasPrefix("itms-appss://") {
                    if let url = URL(string: requestURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    return decisionHandler(.cancel)
                }
            }

            print("requestURL: \(requestURL.absoluteString)")
        }

        switch navigationAction.navigationType {
        case .linkActivated:
            break
        case .formSubmitted:
            break
        case .backForward:
            break
        case .reload:
            break
        case .formResubmitted:
            break
        case .other:
            break
        default:
            break
        }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if challenge.previousFailureCount == 0, let trust = challenge.protectionSpace.serverTrust {
                // 如果没有错误的情况下，创建一个凭证，并使用证书
                let credential = URLCredential(trust: trust)
                completionHandler(.useCredential, credential)
            } else {
                // 验证失败，取消本次验证
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }

    /// 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }

    /// 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }

    /// 页面加载失败时调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("\(#function) error: \(error)")
    }
    
    /// 跳转失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("\(#function) error: \(error)")
    }
}

extension BaseWebViewController: WKUIDelegate {
    /// 新建WKWebView
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let isMainFrame = navigationAction.targetFrame?.isMainFrame ?? false
        if isMainFrame == false {
            webView.load(navigationAction.request)
        }
        return nil
    }

    /// 对应js的Alert方法
    /// web界面中有弹出警告框时调用
    ///
    /// - Parameters:
    ///   - webView           实现该代理的webview
    ///   - message           警告框中的内容
    ///   - frame             主窗口
    ///   - completionHandler 警告框消失调用
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            completionHandler()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) -> Void in
            completionHandler()
        }))
        present(alert, animated: true, completion: nil)
    }

    /// 对应js的confirm方法
    /// web界面中有弹出警告框时调用
    ///
    /// - Parameters:
    ///   - webView           实现该代理的webview
    ///   - message           警告框中的内容
    ///   - frame             主窗口
    ///   - completionHandler 警告框消失调用
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) -> Void in
            completionHandler(false)
        }))
        present(alert, animated: true, completion: nil)
    }

    /// 对应js的prompt方法
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) -> Void in
            textField.textColor = UIColor.red
        }
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            completionHandler(alert.textFields?.first?.text)
        }))
        present(alert, animated: true, completion: nil)
    }
}
