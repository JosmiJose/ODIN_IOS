//
//  newsDetails.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 21/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import WebKit
class GenericWebViewController: UIViewController ,WKUIDelegate {
var url:String?
var pageTitle:String?
    @IBAction func backPressed(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
   // @IBOutlet weak var webview: WKWebView!
    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title=pageTitle
        webView.load(URLRequest(url: URL(string: url!)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
