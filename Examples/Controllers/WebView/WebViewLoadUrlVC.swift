//
//  WebViewLoadUrlVC.swift
//  Examples
//
//  Created by Ashoka on 26/12/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit
import WebKit

class WebViewLoadUrlVC: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupWebView()
        loadWeb()
    }
    
    func setupWebView() {
        // observe progress to update progressView
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: [.new], context: nil)
        webView.addObserver(self, forKeyPath: "title", options: [.new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        log.info("keypath:\(String(describing: keyPath))\nobject:\(String(describing: object))\nchange:\(String(describing: change))")
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = progressView.progress == Float(1)
        self.title = webView.title
    }
    
    func loadWeb() -> Void {
        let wechatUrl = "https://mp.weixin.qq.com/s/WeA3EK8LL-Zs6d72M4PPrA"
        let yturl = "https://www.youtube.com/watch?v=8j9zMok6two"
        // http request required enable set "Allow Arbitrary Loads in Web Content" in plist
        let blog = "http://jashoka.com"
        guard let url = URL(string: wechatUrl) else {
            return
        }
        let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10)
        webView.load(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
