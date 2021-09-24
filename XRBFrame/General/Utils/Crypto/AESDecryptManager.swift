//
//  AESDecryptManager.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import WebKit

enum AESDecryptResult {
    case success(String)
    case failure(Error?)
}

class AESDecryptManager: NSObject {
    private var webView: WKWebView!
    private var isLoaded: Bool = false
    private var ciphertext: String = ""
    private var password: String = ""
    private var completion: ((AESDecryptResult) -> Void)?
    
    override init() {
        super.init()
        
        setupView()
    }
        
    private func setupView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = false

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = WKUserContentController()

        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.showsVerticalScrollIndicator = true
        webView.scrollView.showsHorizontalScrollIndicator = true
        webView.navigationDelegate = self
    }
        
    private func addScriptMessageHandlers(_ scriptMessageHandler: WKScriptMessageHandler, forNames names: [String]) {
        let userContentController = webView.configuration.userContentController
        names.forEach { (name) in
            userContentController.add(scriptMessageHandler, name: name)
        }
    }

    private func removeAllScriptMessageHandlers(forNames names: [String]) {
        let userContentController = webView.configuration.userContentController
        names.forEach { (name) in
            userContentController.removeScriptMessageHandler(forName: name)
        }
    }
}

extension AESDecryptManager {
    /// AES解密
    ///
    /// - Parameters:
    ///   - ciphertext: 密文
    ///   - password: 密码
    ///   - completion: 解密完成
    func decrypt(ciphertext: String,
                 password: String = "hiconiptv2019",
                 completion: @escaping (AESDecryptResult) -> Void) {
        
        self.ciphertext = ciphertext
        self.password = password
        self.completion = completion
        
        addScriptMessageHandlers(self, forNames: ["decryptedText"])

        if isLoaded {
            performDecryptionInteraction()
        } else {
            loadAESDecryptHtml()
        }
    }
}

extension AESDecryptManager {
    private func loadAESDecryptHtml() {
        if let url = Bundle.main.url(forResource: "AESDecrypt", withExtension: "html") {
            webView.load(URLRequest(url: url))
        } else {
            completeDecryption(.failure(nil))
        }
    }

    private func performDecryptionInteraction() {
        let javaScriptString = "decrypt('\(ciphertext)', '\(password)')"
        webView.evaluateJavaScript(javaScriptString) { [weak self] (response, error) in
            guard let self = self else { return }
            if let error = error {
                self.completeDecryption(.failure(error))
            }
        }
    }
    
    private func completeDecryption(_ result: AESDecryptResult) {
        completion?(result)
        removeAllScriptMessageHandlers(forNames: ["decryptedText"])
    }
}

extension AESDecryptManager: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if isLoaded == false {
            isLoaded = true
            performDecryptionInteraction()
        }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        completeDecryption(.failure(error))
    }
}

extension AESDecryptManager: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let name = message.name
        switch name {
        case "decryptedText":
            if let text = message.body as? String {
                completeDecryption(.success(text))
            } else {
                completeDecryption(.failure(nil))
            }
        default:
            completeDecryption(.failure(nil))
        }
    }
}
