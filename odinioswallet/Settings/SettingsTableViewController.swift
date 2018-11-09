//
//  SettingsTableViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 27/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster
import EzPopup
class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var walletId: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var accountStatus: UILabel!
    var kycStatus:String = Constants.kycStatusTypes.notStarted
    
    var curIndexPath:IndexPath?
    @IBOutlet weak var seedCell: UITableViewCell!
    @IBOutlet weak var privateKeyCell: UITableViewCell!
    @IBOutlet weak var accountStatusCell: UITableViewCell!
    @IBOutlet weak var walletIdCell: UITableViewCell!
    @IBOutlet weak var emailCell: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileNetworkCall()
        let headerNib = UINib.init(nibName: "DemoHeaderView", bundle: Bundle.main)
        self.tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "DemoHeaderView")
    }
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DemoHeaderView") as! DemoHeaderView
        
        if(section==0)
        {
        headerView.lblTitle.text = NSLocalizedString("settings_section_wallet", comment: "")
        }
        else if(section==1){
              headerView.lblTitle.text = NSLocalizedString("settings_section_security", comment: "")
        }
        else if(section==2){
            headerView.lblTitle.text = NSLocalizedString("settings_section_app", comment: "")
        }
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    func getProfileNetworkCall()
    {
        Helper.showLoadingAlert(controller: self)
        let token = NSLocalizedString("auth_prefix", comment: "")+" "+Helper.readPref(key:Constants.userToken.userTokenKey)
        let header = [
            "Content-Type" : "application/json; charset=utf-8",
            "Authorization" : token
        ]
        
        
        let object = RestClient.postRequest(method:HTTPMethod.get,url: "api/users/details/get/",header:header, parameters: nil,completion: { [weak self] data in

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self?.dismiss(animated: true)
            }
           
            if(data != nil)
            {
                let status = data["status"]
                if(status).boolValue
                {
                    self?.kycStatus=data["kyc_status"].stringValue
                    Helper.savePref(key:Constants.kycStatus.kycStatusKey, value: (self?.kycStatus)!)
                    Helper.savePref(key:Constants.kycStatus.kycObjectKey, value: data["result"].rawString()!)
                  self?.FillData(result: data["result"])
                    self?.tableView.reloadData()
                        if(self?.kycStatus == Constants.kycStatusTypes.notStarted || self?.kycStatus == Constants.kycStatusTypes.pending)
                        {
                            self?.hideAccountFields()
                        }else{
                            self?.FillData(result: data["result"])
                        }
                    }
                    
                
            }else{
                self?.hideAccountFields()
            }
        })
    }
   
    func hideAccountFields()
    {
        walletIdCell.isHidden=true
        privateKeyCell.isHidden=true
        seedCell.isHidden=true
    }
    func FillData(result:JSON)
    {
        email.text=result["email"].stringValue
        walletId.text=result["wallet_id"].stringValue
        if(result["kyc_flag"].stringValue==Constants.kycStatusTypes.notStarted)
        {
             accountStatus.text=NSLocalizedString("status_not_updated", comment: "")
        }
        else if(result["kyc_flag"].stringValue==Constants.kycStatusTypes.pending)
        {
            accountStatus.text=NSLocalizedString("status_pending", comment: "")
        }
        else if(result["kyc_flag"].stringValue==Constants.kycStatusTypes.approved)
        {
            accountStatus.text=NSLocalizedString("status_approved", comment: "")
        }
        else if(result["kyc_flag"].stringValue==Constants.kycStatusTypes.rejected)
        {
            accountStatus.text=NSLocalizedString("status_rejected", comment: "")
        }
       
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section==0)
        {
        switch indexPath.row {
        case 1 :
            UIPasteboard.general.string = walletId.text
            Toast(text: NSLocalizedString("copied_to_clipboard", comment: "")).show()
            tableView.deselectRow(at: indexPath, animated: true)
        case 3:
            curIndexPath=indexPath
            TransPinMatchedManager.curTransMode="PRIVATE"
            Helper.startPinAuth(mode: "VERIFY", delegate: self)
        case 4:
            curIndexPath=indexPath
            TransPinMatchedManager.curTransMode="SEED"
            Helper.startPinAuth(mode: "VERIFY", delegate: self)
        default:
            print("default")
        }
        }
        if(indexPath.section==1)
        {
            switch indexPath.row {
            case 0:
                TransPinMatchedManager.curTransMode="CHANGE"
                Helper.startPinAuth(mode: "VERIFY", delegate: self)
            case 1:
                 tableView.deselectRow(at: indexPath, animated: true)
                 changePassword()
            default:
                print("default")
            }
        }else if(indexPath.section==2)
        {
            switch indexPath.row {
            case 0:
                
                Helper.openGenericWebview(url:"api/about/",controller:self,title:NSLocalizedString("title_about_us", comment: ""))
            case 1:
                
                Helper.openGenericWebview(url:"api/tnc/",controller:self,title:NSLocalizedString("options_tos", comment: ""))
            default:
                print("default")
            }
        }
    }
    func showWalletDetails(key:String,indexPath:IndexPath)
    {
        var api=""
        if(key=="Private Key")
        {
            api="api/settings/user/key/"
        }
        else{
             api="api/settings/user/seed/"
        }
        Helper.showLoadingAlert(controller: self)
        let token = NSLocalizedString("auth_prefix", comment: "")+" "+Helper.readPref(key:Constants.userToken.userTokenKey)
        let header = [
            "Content-Type" : "application/json; charset=utf-8",
            "Authorization" : token
        ]
        
        
        let object = RestClient.postRequest(method:HTTPMethod.get,url: api,header:header, parameters: nil,completion: { [weak self] data in
            
           
            
            if(data != nil)
            {
                let status = data["status"]
                if(status).boolValue
                {
                    let result=data["result"]
                    let msg=result["message"].stringValue
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self?.dismiss(animated: true)
                        {
                             self?.showGeneralDialog(key: key,msg: msg,indexPath:indexPath)
                        }
                    }
                   
                }
                
                
            }else{
                
            }
        })
    }
    func showGeneralDialog(key:String,msg:String,indexPath:IndexPath)
    {
        let alert = UIAlertController(title:key , message:msg ,preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: NSLocalizedString("copy_to_clipboard", comment: "") , style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            UIPasteboard.general.string = msg
            Toast(text: NSLocalizedString("copied_to_clipboard", comment: "")).show()
            self.tableView.deselectRow(at: indexPath, animated: true)
        })
        let continueAction = UIAlertAction(title: NSLocalizedString("continue", comment: "") , style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            self.tableView.deselectRow(at: indexPath, animated: true)
            
        })
        alert.addAction(acceptAction)
        alert.addAction(continueAction)
        self.present(alert, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) // No need for semicolon
        if(TransPinMatchedManager.curTransMode == "CHANGE" && TransPinMatchedManager.matched)
        {
            TransPinMatchedManager.curTransMode=""
            TransPinMatchedManager.matched=false
            changePin()
        }
        else if(TransPinMatchedManager.curTransMode == "PRIVATE")
        {
             TransPinMatchedManager.curTransMode=""
            showWalletDetails(key:"Private Key",indexPath: curIndexPath!)
        }
        else if(TransPinMatchedManager.curTransMode == "SEED")
        {
            TransPinMatchedManager.curTransMode=""
            showWalletDetails(key:"Seed",indexPath: curIndexPath!)
        }
        else if(TransPinMatchedManager.changed)
        {
            TransPinMatchedManager.changed=false
             Toast(text: NSLocalizedString("pin_changed_notice", comment: "")).show()
        }
    }
    func changePin()
    {
        Helper.startPinAuth(mode: "CHANGE",delegate: self)
    }
    func changePassword()
    {
        let changePasswordVC = ChangePasswordViewController.instantiate()
        let popupVC = PopupViewController(contentController: changePasswordVC!, popupWidth: 250 , popupHeight: 250)
        popupVC.cornerRadius = 5
        changePasswordVC?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(popupVC, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if(self.kycStatus==Constants.kycStatusTypes.notStarted || self.kycStatus==Constants.kycStatusTypes.pending )
        {
            if(indexPath.section==0)
            {
            if(indexPath.row == 1 || indexPath.row==3 || indexPath.row==4)
            {
                return 0
            }else{
                return super.tableView(tableView, heightForRowAt: indexPath)
                }
            }
        }else if(self.kycStatus==Constants.kycStatusTypes.notStarted){
            if(indexPath.row == 0 || indexPath.row==2)
            {
                return 0
            }else{
                return super.tableView(tableView, heightForRowAt: indexPath)
            }
        }
        else{
             return super.tableView(tableView, heightForRowAt: indexPath)
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
        }
}
