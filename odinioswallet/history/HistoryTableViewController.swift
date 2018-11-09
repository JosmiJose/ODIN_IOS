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

class HistoryTableViewController: UITableViewController,OptionButtonsDelegate {
    func txHashTapped(at index: IndexPath) {
        let hash=dataSources[index.row-1].txHash
        guard let url = URL(string: "https://etherscan.io/tx/"+hash!) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    var dataSources=[HistoryItem]()
    var showLoading:Bool=false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHistory()
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
        
        if(showLoading)
        {
             Helper.showLoadingAlert(controller: self)
        }
        
        let object = RestClient.postRequest(method:HTTPMethod.get,url: "api/user/transaction/history/",header:header, parameters: nil,completion: { [weak self] data in
            self?.refreshControl?.endRefreshing()
            if(self?.showLoading)!
            {
                self?.dismiss(animated: true, completion: nil)
            }
            print(data)
            if(data != nil)
            {
                let status = data["status"]
                if(status).boolValue
                {
                    let result:JSON=data["result"]
                    if(result["values"].arrayValue.count>0)
                    {
                        self?.appendHistories(histories: Helper.getHistories(values: result["values"].arrayValue))
                        
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
    func appendHistories(histories:[HistoryItem])
    {
        let kycObject:JSON = Helper.getProfileObject()
        dataSources.removeAll()
        for history in histories{
            if(restorationIdentifier=="sentTable")
            {
                if(history.fromAddress==kycObject["wallet_id"].stringValue)
                {
                    dataSources.append(history)
                }
            }else if(restorationIdentifier=="recievedTable"){
                if(history.toAddress==kycObject["wallet_id"].stringValue)
                {
                    dataSources.append(history)
                }
            }
            
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "rowCell", for: indexPath) as! historyRowCell
               self.tableView.rowHeight=65
              let historyItem=dataSources[indexPath.row-1]
               cell.token.text=historyItem.token
            cell.delegate = self
            cell.indexPath = indexPath
            cell.amount.text=Helper.getBalanceFormattedString(number: historyItem.amount!)
            if(!(historyItem.txHash?.isEmpty)!)
            {
             cell.txHash.setTitle(historyItem.txHash!, for: .normal)
            }
            else{
                if(historyItem.isDbToken)!
                {
                cell.txHash.setTitle(NSLocalizedString("not_available", comment: ""), for: .normal)
                }else{
                    cell.txHash.isHidden=true
                }
            }
            cell.txHash.tag = indexPath.row;
            cell.date.text=(Helper.getFormattedDate(date: historyItem.txTimestamp!))
            cell.status.text=historyItem.statusMsg
            return cell
        }
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }

}
