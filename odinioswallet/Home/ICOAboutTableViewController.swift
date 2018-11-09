//
//  ICOAboutTableViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 16/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import SwiftyJSON
class ICOAboutTableViewController: UITableViewController {
    @IBOutlet weak var estDate: UILabel!
    @IBOutlet weak var contactAddress: UILabel!
    @IBOutlet weak var ticker: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var industry: UILabel!
    @IBOutlet weak var tokenRate: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var icoEndDate: UILabel!
    @IBOutlet weak var icoStartDate: UILabel!
    @IBOutlet weak var logoIcon: UIImageView!
    @IBOutlet weak var totalSupply: UILabel!
    var company:Company?
    @IBOutlet weak var companyDesc: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
     self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        if(!(company?.companyLogo?.isEmpty)!)
        {
             Helper.setImage(imageView: logoIcon, imageString: (company?.companyLogo)!,placeholder: "place_holder")
        }
        
       companyName.text=company?.companyName
        companyDesc.text=company?.companyOverview
       let rateValue=1/(company?.odinEquivalent)!
       let rateText="1 ODIN ="+Helper.getBalanceFormattedString(number: rateValue)+" "+(company?.preIcoTicker)!
        tokenRate.text=rateText
       industry.text=company?.industryType
        website.text=company?.website
        ticker.text=company?.preIcoTicker
         let kycObject:JSON = Helper.getProfileObject()
        if(kycObject["is_subscribed"].boolValue)
        {
            let supply=(company?.totalSupply!)!+(company?.permiumSupply!)!
            totalSupply.text=Helper.getBalanceFormattedString(number: supply)+" "+(company?.preIcoTicker!)!
        }
        else{
            totalSupply.text=Helper.getBalanceFormattedString(number: (company?.totalSupply!)!)+" "+(company?.preIcoTicker!)!
        }
         icoStartDate.text=company?.icoStartDate
        icoEndDate.text=company?.icoEndDate
        contactAddress.text=company?.contractAddress
        estDate.text=company?.dateOfTokenRelease
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

   
}
