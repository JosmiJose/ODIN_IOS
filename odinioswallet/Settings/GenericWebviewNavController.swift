//
//  newsDetailsNavController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 21/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit

class GenericWebviewNavController: UINavigationController {
    var url:String?
    var pageTitle:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let VC=childViewControllers[0] as! GenericWebViewController
        VC.url=self.url
           VC.pageTitle=self.pageTitle
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
