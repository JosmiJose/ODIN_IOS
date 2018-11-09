//
//  TrialViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 04/07/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class ICOAboutViewController: UIViewController ,IndicatorInfoProvider {
 var company:Company?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var type = ""
    var itemInfo = IndicatorInfo(title:NSLocalizedString("ico_about", comment: ""))
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "aboutEmbed" {
            let nextScene = segue.destination as? ICOAboutTableViewController
            nextScene?.company=self.company
        }
    }
    

}
