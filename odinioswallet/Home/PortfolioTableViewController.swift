//
//  PortfolioTableViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 08/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class PortfolioTableViewController: UITableViewController {
    var dataSources=[Token]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(reloadTokens), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
    }
    @objc func reloadTokens() {
         getTokens()
  
    }
    func getTokens()
    {
        let token = NSLocalizedString("auth_prefix", comment: "")+" "+Helper.readPref(key:Constants.userToken.userTokenKey)
        let header = [
            "Content-Type" : "application/json; charset=utf-8",
            "Authorization" : token
        ]
        
        
        let object = RestClient.postRequest(method:HTTPMethod.get,url: "api/user/transaction/tokens/",header:header, parameters: nil,completion: { [weak self] data in
            self?.refreshControl?.endRefreshing()
            print(data)
            if(data != nil)
            {
                let status = data["status"]
                if(status).boolValue
                {
                    let result:JSON=data["result"]
                    if(result["values"].arrayValue.count>0)
                    {
                        self?.appendTokens(tokens: Helper.getTokens(values: result["values"].arrayValue))
                        
                    }
                    
                }
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if dataSources.count > 0 {
              TableViewHelper.RemoveEmptyMessage(viewController: self)
            return 1
        } else {
            TableViewHelper.EmptyMessage(message:NSLocalizedString("no_data_available", comment: ""), viewController: self)
            
            return 0
        }
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSources.count+1
    }
    func appendTokens(tokens:[Token])
    {   dataSources.removeAll()
        for token in tokens{
            dataSources.append(token)
        }
        self.tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row==0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! portfolioHeaderCell
               self.tableView.rowHeight=40
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "rowCell", for: indexPath) as! portfolioRowCell
               self.tableView.rowHeight=40
              let token=dataSources[indexPath.row-1]
               cell.tokenName.text=token.tokenLongName
            cell.tokenHoldings.text=Helper.getBalanceFormattedString(number: token.holdings!)+" "+token.tokenName!
            cell.tokenOdinValue.text=(Helper.getBalanceFormattedString(number: token.odinEquivalent!))
            Helper.setImage(imageView:  cell.tokenIcon, imageString:token.tokenImage!,placeholder: "place_holder")
            return cell
        }
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let tokenItems:JSON=Helper.getTokens()
        {
        appendTokens(tokens: Helper.getTokens(values: tokenItems.arrayValue))
        }
       
    }

}
