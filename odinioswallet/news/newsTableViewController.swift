//
//  newsTableViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 21/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class newsTableViewController: UITableViewController {
    var dataSources=[newsItem]()
    var showLoading:Bool=false
    override func viewDidLoad() {
        super.viewDidLoad()
           self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(reloadNews), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
         initNews()
    }

    @objc func reloadNews() {
        showLoading=false
        getNews()
        
    }
    func initNews()
    {
        showLoading=true
        getNews()
    }
    func getNews()
    {
        let token = NSLocalizedString("auth_prefix", comment: "")+" "+Helper.readPref(key:Constants.userToken.userTokenKey)
        let header = [
            "Content-Type" : "application/json; charset=utf-8",
            "Authorization" : token
        ]
        
        if(self.showLoading)
        {
            DispatchQueue.main.async {
                 Helper.showLoadingAlert(controller: self)
            }
        }
        
        let object = RestClient.postRequest(method:HTTPMethod.get,url: "api/user/activity/news/",header:header, parameters: nil,completion: { [weak self] data in
            self?.refreshControl?.endRefreshing()
            if(self?.showLoading)!
            {
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                }
               
            }
            if(data != nil)
            {
                let status = data["status"]
                if(status).boolValue
                {
                    let result:JSON=data["result"]
                    if(result["values"].arrayValue.count>0)
                    {
                     self?.appendNews(items: Helper.getNews(values: result["values"].arrayValue))
                        
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
         return dataSources.count
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    func appendNews(items:[newsItem])
    {
        let kycObject:JSON = Helper.getProfileObject()
        dataSources.removeAll()
        for item in items{
            dataSources.append(item)
        }
        self.tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! newsListRowCell
            self.tableView.rowHeight=80
            let item=dataSources[indexPath.row]
            cell.title.text=item.title
            cell.desc.text=item.desc
        Helper.setImage(imageView: cell.newsImage, imageString: item.uploadImage!,placeholder:"news_placeholder")
            
            return cell
}
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "news", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "newsDetails") as! newsDetailsNavController
        viewController.news=dataSources[indexPath.row]
        self.present(viewController, animated: false)
    }
}
