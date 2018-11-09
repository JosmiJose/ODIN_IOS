//
//  ICOAboutTableViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 16/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import SwiftyJSON
import Cosmos
class ICOReviewsTableViewController: UITableViewController {
   
    @IBOutlet weak var review: UILabel!
    var company:Company?
    var noRating:Bool=false
   
    @IBOutlet weak var ratingView: CosmosView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
     self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
       
        if((company?.companyRating)!>0)
        {
        ratingView.rating=Double((company?.companyRating)!)
        }
        else{
            ratingView.isHidden=true
            noRating=true
        }
        if((company?.companyReview?.isEmpty)! && noRating)
        {
            review.text=NSLocalizedString("no_review", comment: "")
        }
        else{
        review.text=company?.companyReview
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

   
}
