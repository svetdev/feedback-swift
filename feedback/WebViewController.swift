//
//  WebViewController.swift
//  feedback
//
//  Created by Andrey Kasatkin on 12/14/16.
//  Copyright © 2016 Svetliy. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    let formURL = "https://svetliy.herokuapp.com/contact"
    var formHasBeenLoaded = false
    
    @IBOutlet var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addWebView()
        loadURL(url: formURL)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

        let webViewKeyPathsToObserve = ["estimatedProgress"]
        for keyPath in webViewKeyPathsToObserve {
            webView.removeObserver(self, forKeyPath: keyPath)
        }
    }
    
    func addWebView() {
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView!)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-[webView]-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: ["webView": webView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[webView]-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: ["webView": webView]))
        
        let webViewKeyPathsToObserve = ["estimatedProgress"]
        for keyPath in webViewKeyPathsToObserve {
            webView.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
        }

    }
    
    func loadURL(url: String!) {
        guard let url = NSURL(string: url) else {return}
        let request = NSMutableURLRequest(url:url as URL)
        webView.load(request as URLRequest)
    }
    
    //track progress
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else { return }
        
        switch keyPath {
            
        case "estimatedProgress":
            // If you are using a `UIProgressView`, this is how you update the progress
            view.bringSubview(toFront: progressView)
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.progress = Float(webView.estimatedProgress)
            break
            
        default:
            break
        }

    }
    
    //MARK: WKWebViewDelegate
    func webView(_ webView: WKWebView,
                          didFinish navigation: WKNavigation!){
        progressView.setProgress(0.0, animated: false)
        if (webView.url?.absoluteString == formURL){
            formHasBeenLoaded = true
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
     
        if (formHasBeenLoaded){
            
            checkInput(webView: webView, input: "name") { (result: Bool) in
                if (result == true){
                    self.checkInput(webView: webView, input: "email") { (result: Bool) in
                        if (result == true){
                            self.checkInput(webView: webView, input: "message") { (result: Bool) in
                                if (result == true){
                                    decisionHandler(.allow)
                                } else {
                                    decisionHandler(.cancel)
                                }
                            }
                        } else {
                            decisionHandler(.cancel)
                        }
                    }
                } else {
                    decisionHandler(.cancel)
                }
            }
        } else {
            decisionHandler(.allow)
        }
        
    }
    
    func checkInput(webView: WKWebView, input: String, completion: @escaping (_ result: Bool) -> Void) {
        let javascriptCommand = "document.getElementById('\(input)').children[1].value"
        webView.evaluateJavaScript(javascriptCommand) { (result, error) in
            if error == nil {
                let textFieldInput = result as! String
                if textFieldInput.isEmpty {
                    
                    let errorMessage = "Please enter \(input)"
                    let alertController = UIAlertController(title: "Form is not completed", message: errorMessage, preferredStyle: .alert)
                
                    let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                    }
                    alertController.addAction(OKAction)
                    
                    self.present(alertController, animated: true) {
                    
                    }
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
}
