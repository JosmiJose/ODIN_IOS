//
//  pointsInfoTableViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 20/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class membershipInfoTableViewController: UITableViewController,UICollectionViewDataSource  {
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSources=[packageItem]()
    @IBOutlet weak var availablePoints: UILabel!
    @IBOutlet weak var membershipStatus: UILabel!
    var showLoading:Bool=false
    var curItem:packageItem?
    @IBAction func howToEarnPoints(_ sender: Any) {
        Helper.openInternalUrl(path: "api/odin-points/")
    }
    let reuseIdentifier = "collectionViewCellId"
    
   
    @IBOutlet weak var header: UILabel!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if dataSources.count > 0 {
            TableViewHelper.RemoveEmptyMessage(viewController: self)
            return 1
        } else {
            TableViewHelper.EmptyMessage(message:NSLocalizedString("no_data_available", comment: ""), viewController: self)
            
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        let item=dataSources[indexPath.row]
        let pointsNo=String(item.points!)
        cell.points.text=pointsNo
    cell.noOfDays.text=NSLocalizedString("subscription_duration_part_one", comment: "")+" "+String(item.noOfDays!)+" "+NSLocalizedString("subscription_duration_part_two", comment: "")
        cell.subscribe.tag=indexPath.row
        cell.subscribe.addTarget(self, action: #selector(self.subscribe(_:)), for: .touchUpInside)
        
        return cell
    }
    @objc func subscribe(_ sender: AnyObject) {
         let kycObject:JSON = Helper.getProfileObject()
          if(kycObject["is_subscribed"].boolValue)
          {
            
                Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message: NSLocalizedString("you_are_memeber", comment: ""), controller: self)

          }
          else{
            curItem=dataSources[sender.tag]
            TransPinMatchedManager.curTransMode="MEMBER"
            Helper.startPinAuth(mode: "VERIFY", delegate: self)
          }
       
       
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
     
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            let kycObject:JSON = Helper.getProfileObject()
        if(kycObject != nil)
        {
      availablePoints.text=String(kycObject["odin_points"].intValue)
        if(kycObject["is_subscribed"].boolValue)
        {
           membershipStatus.text=NSLocalizedString("you_are_memeber", comment: "")
        }
        else{
         membershipStatus.text=NSLocalizedString("you_are_not_memeber", comment: "")
        }
        }
        else{
            availablePoints.text="0"
            membershipStatus.text=NSLocalizedString("you_are_not_memeber", comment: "")
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(reloadPackages), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.initPackages()
        }
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

@objc func reloadPackages() {
    showLoading=false
    getPackages()
    
}
func initPackages()
{
    showLoading=true
    getPackages()
}
func getPackages()
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
    
    let object = RestClient.postRequest(method:HTTPMethod.get,url: "api/user/activity/subscribe/get/all/",header:header, parameters: nil,completion: { [weak self] data in
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
                     self?.header.text=NSLocalizedString("please_select_package", comment: "")
                    self?.appendPackages(items:Helper.getPackageItems(values: result["values"].arrayValue))
                    
                }
                else{
                    self?.header.text=NSLocalizedString("no_available_packages", comment: "")
                }
                
            }
        }
    })
}
    func subscribePackage(id:Int)
    {
        let token = NSLocalizedString("auth_prefix", comment: "")+" "+Helper.readPref(key:Constants.userToken.userTokenKey)
        let header = [
            "Content-Type" : "application/json; charset=utf-8",
            "Authorization" : token
        ]
       
            Helper.showLoadingAlert(controller: self)
   
        let urlString="api/user/activity/subscription/"+String(id)
        let object = RestClient.postRequest(method:HTTPMethod.get,url:urlString ,header:header, parameters: nil,completion: { [weak self] data in
        
            if(data != nil)
            {
                let status = data["status"]
                if(status).boolValue
                {
                    let alert = UIAlertController(title:NSLocalizedString("subscribe_success", comment: "") , message:NSLocalizedString("subscribe_success_msg",comment: "") ,preferredStyle: .alert)
                    let acceptAction = UIAlertAction(title: NSLocalizedString("back_to_main", comment: "") , style: .default, handler: { (action) -> Void in
                        // Get 1st TextField's text
                        self?.dismiss(animated: true, completion: {});
                        self?.navigationController?.popViewController(animated: true);
                    })
                    
                    alert.addAction(acceptAction)
                    self?.dismiss(animated: true) {
                        self?.present(alert, animated: true)
                    }
                }else{
                    self?.dismiss(animated: true) {
                        self?.showError(data: data)
                    }
                }
            }else
            {
                 self?.dismiss(animated: true, completion: nil)
            }
        })
    }
    func showError(data:JSON)
    {
        let msgObj=data["result"]
        let msg=msgObj["message"]
        if(msg.stringValue != nil && !msg.stringValue.isEmpty)
        {
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:msg.stringValue, controller: self)
        }
        else{
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message: NSLocalizedString("subscribe_error", comment: ""), controller: self)
        }
    }
    func appendPackages(items:[packageItem])
    {
        dataSources.removeAll()
        for item in items{
            dataSources.append(item)
        }
        self.collectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(TransPinMatchedManager.curTransMode == "MEMBER")
        {
            TransPinMatchedManager.curTransMode=""
            subscribePackage(id: (curItem?.subscribe_id!)!)
        }
    }
}
