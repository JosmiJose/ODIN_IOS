//
//  pointsInfoTableViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 20/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import SwiftyJSON
class pointsInfoTableViewController: UITableViewController {

    @IBAction func howToEarnPoints(_ sender: Any) {
        Helper.openInternalUrl(path: "api/odin-points/")
    }
    @IBOutlet weak var points: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            let kycObject:JSON = Helper.getProfileObject()
            points.text=String(kycObject["odin_points"].intValue)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
