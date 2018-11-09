//
//  TrialViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 04/07/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class ICOTeamViewController: UIViewController ,IndicatorInfoProvider {
 var company:Company?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var type = ""
    var itemInfo = IndicatorInfo(title:NSLocalizedString("ico_team", comment: ""))
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "teamSegue" {
            let nextScene = segue.destination as? teamCollectionViewController
            nextScene?.company=self.company
        }
    }

}
