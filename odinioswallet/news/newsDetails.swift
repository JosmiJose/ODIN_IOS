//
//  newsDetails.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 21/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import WebKit
class newsDetails: UIViewController,WKUIDelegate {

    @IBAction func backPressed(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    //@IBOutlet weak var webview: WKWebView!
    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    var news:newsItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title=news?.title
        webView.loadHTMLString((news?.body)!, baseURL: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            let url = navigationAction.request.url
            if url?.description.range(of: "http://") != nil || url?.description.range(of: "https://") != nil || url?.description.range(of: "mailto:") != nil || url?.description.range(of: "tel:") != nil  {
                UIApplication.shared.openURL(url!)
            }
        }
        return nil
    }
}
