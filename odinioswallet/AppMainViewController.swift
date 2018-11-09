//
//  AppMainViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 02/07/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation
import QRCodeReader
import Crashlytics
import SideMenu
class AppMainViewController: UITabBarController,QRCodeReaderViewControllerDelegate {
    var kycStatus:String = ""
    var profileLoaded=false
    override func viewDidLoad() {
        super.viewDidLoad()
          setSideMenu()
        self.tabBarController?.tabBar.isTranslucent = false
        kycStatus=Helper.readPref(key:Constants.kycStatus.kycStatusKey)
    }

    func getProfileNetworkCall(fromSync:Bool,syncSource:Int)
    {
        Helper.showLoadingAlert(controller: self)
        let token = NSLocalizedString("auth_prefix", comment: "")+" "+Helper.readPref(key:Constants.userToken.userTokenKey)
        let header = [
            "Content-Type" : "application/json; charset=utf-8",
            "Authorization" : token
        ]
        
        
        let object = RestClient.postRequest(method:HTTPMethod.get,url: "api/users/details/get/",header:header, parameters: nil,completion: { [weak self] data in
            self?.profileLoaded=true
            if(data != nil)
            {
                if(data["detail"].stringValue=="Invalid token.")
                {
                    self?.dismiss(animated: true) {
                    self?.smoothEscape()
                    }
                }
                else
                {
                
                let status = data["status"]
                if(status).boolValue
                {
                    self?.kycStatus=data["kyc_status"].stringValue
                    Helper.savePref(key:Constants.kycStatus.kycStatusKey, value: (self?.kycStatus)!)
                    Helper.savePref(key:Constants.kycStatus.kycObjectKey, value: data["result"].rawString()!)
                    self?.dismiss(animated: true) {
                        
                        if(self?.kycStatus == Constants.kycStatusTypes.notStarted)
                        {
                            if(fromSync)
                            {
                                self?.stopSync(syncSource: syncSource)
                            }
                            let viewC = self?.viewControllers![0] as! UINavigationController
                            if let sendVC = viewC.viewControllers[0] as? SendViewController {
                            sendVC.showEmptyMsgLayout(msg: NSLocalizedString("need_verify", comment: ""))
                            }
                            self?.askToUpdateProfile()
                        }else{
                            self?.setBalance(data:data, fromSync:fromSync,syncSource: syncSource)
                        }
                    }
                    
                }
                }
            }
        })
    }
    func smoothEscape()
    {
        Helper.clearUserDefaults()
        Helper.isLoggedOut=true
        Helper.startLandingPage()
    }
    func stopSync(syncSource:Int)
    {
        let viewC = self.viewControllers![syncSource] as! UINavigationController
        if(syncSource==0)
        {
            if let sendVC = viewC.viewControllers[0] as? SendViewController {
             sendVC.stopSync()
                
            }
        }
         
    }
    func getTokens(fromSync:Bool,syncSource:Int)
    {
        Helper.showLoadingAlert(controller: self)
        let token = NSLocalizedString("auth_prefix", comment: "")+" "+Helper.readPref(key:Constants.userToken.userTokenKey)
        let header = [
            "Content-Type" : "application/json; charset=utf-8",
            "Authorization" : token
        ]
        
        
        let object = RestClient.postRequest(method:HTTPMethod.get,url: "api/user/transaction/tokens/",header:header, parameters: nil,completion: { [weak self] data in
            self?.dismiss(animated: true, completion: nil)
            if(fromSync)
            {
                self?.stopSync(syncSource: syncSource)
            }
            if(data != nil)
            {
                let status = data["status"]
                if(status).boolValue
                {
                    let viewC = self?.viewControllers![0] as! UINavigationController
                    let sendVC = viewC.viewControllers[0] as? SendViewController
                   
                    let result:JSON=data["result"]
                    let availableTokens=self?.isThereTokens(values: result["values"].arrayValue)
                    if(availableTokens)!
                    {
                        sendVC?.appendTokens(tokens: (Helper.getTokens(values: result["values"].arrayValue)))
                        sendVC?.showContainerLayout()
                        Helper.savePref(key:Constants.tokens.tokensKey, value: (result["values"].rawString())!)
                      
                    }else{
                         sendVC?.showEmptyMsgLayout(msg: NSLocalizedString("no_holdings", comment: ""))
                         Helper.savePref(key:Constants.tokens.tokensKey, value: "")
                    }
                    
                }
            }
        })
    }
    func setSideMenu()
    {
        let storyboard = UIStoryboard(name: "App", bundle: nil)
        let menuLeftNavigationController = storyboard.instantiateViewController(withIdentifier: "slideNav") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuDismissOnPush=true
    }
    func isThereTokens(values:[JSON])->Bool
    {
        
        var avaliableTokens:Bool=false
        let profile:JSON=Helper.getProfileObject()
        let odinBalance=profile["odinBalance"].doubleValue
        let ethBalance=profile["ethBalance"].doubleValue
        if(odinBalance>0)
        {
            avaliableTokens=true
        }else if(ethBalance>0)
        {
            avaliableTokens=true
        }else if(values.count>0)
        {
            avaliableTokens=true
        }
        
        return avaliableTokens
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        if(Helper.isLoggedOut)
        {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "mainInitial") as! UIViewController
        UIApplication.shared.keyWindow?.rootViewController = viewController
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(Connectivity.isConnectedToInternet)
        {
        if(!profileLoaded)
        {
            getProfileNetworkCall(fromSync: false,syncSource: 0)
        }
        }
        else{
            let alert = UIAlertController(title: NSLocalizedString("no_network_error_title", comment: ""), message: NSLocalizedString("no_network_error", comment: ""), preferredStyle: .alert)
            //alert.isModalInPopover = true
            
            let yesAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                 self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(yesAction)
        }
    }
    func askToUpdateProfile()
    {
        let alert = UIAlertController(title: NSLocalizedString("update_profile", comment: ""), message: NSLocalizedString("update_profile_reminder", comment: ""), preferredStyle: .alert)
        //alert.isModalInPopover = true
        
        let yesAction = UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "pager") as! UIViewController
            self.present(viewController, animated: false)
        })
        alert.addAction(yesAction)
        
        let noAction = UIAlertAction(title: NSLocalizedString("polite_no", comment: ""), style: .default, handler: nil)
        alert.addAction(noAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func setBalance(data:JSON,fromSync:Bool,syncSource:Int)
   {
    for i in 0...3 {
        let viewC = self.viewControllers![i] as! UINavigationController
        if(i==0)
        {
            if let sendVC = viewC.viewControllers[0] as? SendViewController {
                sendVC.setBalance(profile: data["result"])
                let  kycStatus=Helper.readPref(key:Constants.kycStatus.kycStatusKey)
                if(kycStatus==Constants.kycStatusTypes.approved)
                {
                    getTokens(fromSync:fromSync,syncSource: syncSource)
                }
                else{
                    sendVC.showEmptyMsgLayout(msg: NSLocalizedString("need_verify", comment: ""))
                }
            }
        }
        else if(i==1)
        {
            if let  homeVC = viewC.viewControllers[0] as? HomeViewController {
                homeVC.setBalance(profile: data["result"])
                homeVC.stopSync()
            }
        }
        else if(i==2)
        {
            if let  historyVC = viewC.viewControllers[0] as? HistoryViewController {
                historyVC.setBalance(profile: data["result"])
                  historyVC.stopSync()
            }
        }
        else if(i==3)
        {
            if let requestVC = viewC.viewControllers[0] as? RequestViewController {
                requestVC.setBalance(profile: data["result"])
                requestVC.stopSync()
            }
        }
    }
    }
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    func processQrCodeResult(result:String)
    {
        let viewC = self.viewControllers![0] as! UINavigationController
      
            if let sendVC = viewC.viewControllers[0] as? SendViewController {
                 selectedIndex = 0
                sendVC.setQRCodeResult(result: result)
               
            }
       
     
    }
}
