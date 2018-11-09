//
//  newsDetailsNavController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 21/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit

class newsDetailsNavController: UINavigationController {
    var news:newsItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        let VC=childViewControllers[0] as! newsDetails
        VC.news=self.news
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
