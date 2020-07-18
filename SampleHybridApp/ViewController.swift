//
//  ViewController.swift
//  SampleHybridApp
//
//  Created by Ömer Faruk Öztürk on 18.07.2020.
//  Copyright © 2020 Omer Faruk Ozturk. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    private var webView: WKWebView!
    private let callbackName = "callback"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentController = WKUserContentController()
        contentController.add(self, name: callbackName)
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        webView = WKWebView(frame: view.frame, configuration: config)
        webView.uiDelegate = self
        view.addSubview(webView)
        
        // load local html file
        let bundleURL = Bundle.main.resourceURL!.absoluteURL
        let html = bundleURL.appendingPathComponent("index.html")
        webView.loadFileURL(html, allowingReadAccessTo:bundleURL)
    }
    
    func sendEvent2WebToIncrementSumByOne() {
        webView.evaluateJavaScript("addToSum('1')", completionHandler: nil)
        print("\"addToSum\" event sent to web.")
    }
}

extension ViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // Handle the events coming from javascript.
        guard message.name == callbackName else { return }
        
        // Access properties through the message body.
        print("Message received from Web: \"\(message.body)\"")
        
        // send back event to web
        sendEvent2WebToIncrementSumByOne()
    }
}


extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {

        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let title = NSLocalizedString("OK", comment: "OK Button")
        let ok = UIAlertAction(title: title, style: .default) { (action: UIAlertAction) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        present(alert, animated: true)
        completionHandler()
    }
}
