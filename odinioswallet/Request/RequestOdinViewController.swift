//
//  TrialViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 04/07/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class RequestOdinViewController: UIViewController ,IndicatorInfoProvider {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var itemInfo = IndicatorInfo(title: NSLocalizedString("odin", comment: ""))
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
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
