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

class pointsHistoryTableViewController: UITableViewController {
    var dataSources=[pointsHistory]()
    var showLoading:Bool=false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(reloadHistory), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
    }
    @objc func reloadHistory() {
         showLoading=false
         getHistory()
  
    }
    func initHistory()
    {
        showLoading=true
        getHistory()
    }
    func getHistory()
    {
        let token = NSLocalizedString("auth_prefix", comment: "")+" "+Helper.readPref(key:Constants.userToken.userTokenKey)
        let header = [
            "Content-Type" : "application/json; charset=utf-8",
            "Authorization" : token
        ]
        
        if(self.showLoading)
        {
             Helper.showLoadingAlert(controller: self)
        }
        
        let object = RestClient.postRequest(method:HTTPMethod.get,url: "api/user/activity/point/history/",header:header, parameters: nil,completion: { [weak self] data in
            self?.refreshControl?.endRefreshing()
            if(self?.showLoading)!
            {
                self?.dismiss(animated: true, completion: nil)
            }
            if(data != nil)
            {
                let status = data["status"]
                if(status).boolValue
                {
                    let result:JSON=data["result"]
                    if(result["values"].arrayValue.count>0)
                    {
                        self?.appendHistories(histories: Helper.getPointsHistory(values: result["values"].arrayValue))
                        
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
    func appendHistories(histories:[pointsHistory])
    {
        let kycObject:JSON = Helper.getProfileObject()
        dataSources.removeAll()
        for history in histories{
            dataSources.append(history)
        }
        self.tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row==0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! historyHeaderCell
               self.tableView.rowHeight=40
            return cell
        }
        else{
              let cell = tableView.dequeueReusableCell(withIdentifier: "rowCell", for: indexPath) as! pointsHistoryRowCell
               self.tableView.rowHeight=40
               let historyItem=dataSources[indexPath.row-1]
               cell.date.text=historyItem.pointDate
               cell.points.text=String(historyItem.pointsAdded!)+" "+NSLocalizedString("points", comment: "")
            
            
            return cell
        }
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
          initHistory()
    }

}
