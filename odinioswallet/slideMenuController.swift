//
//  slideMenuController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 05/07/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import Alamofire
class slideMenuController: UITableViewController {
    var kycStatus:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
           kycStatus=Helper.readPref(key:Constants.kycStatus.kycStatusKey)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 1:
            let storyboard = UIStoryboard(name: "points", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "pointsNav") as! UIViewController
            self.present(viewController, animated: false)
        case 2:
            let storyboard = UIStoryboard(name: "news", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "newsList") as! UIViewController
            self.present(viewController, animated: false)
        case 3:
            let storyboard = UIStoryboard(name: "membership", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "memberNav") as! UIViewController
            self.present(viewController, animated: false)
        case 4:
            if(kycStatus == Constants.kycStatusTypes.pending)
            {
                let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "kyc_pending_nav") as! UINavigationController
                self.present(viewController, animated: false)
            }else{
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "pager") as! UIViewController
            self.present(viewController, animated: false)
            }
        case 5:
             Helper.openGenericWebview(url:"api/faq/",controller:self,title:NSLocalizedString("faq", comment: ""))
        case 6:
            Helper.openGenericWebview(url:"api/help/",controller:self,title:NSLocalizedString("help_center", comment: ""))
        case 7:
            let storyboard = UIStoryboard(name: "settings", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "settingsNav") as! UIViewController
            self.present(viewController, animated: false)
        case 8:
           showLogoutAlert(title: NSLocalizedString("logout_title", comment: ""), message: NSLocalizedString("logout_confirm_msg", comment: ""))
        default:
            print("default")
        }
    }
     func showLogoutAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("logout", comment: ""), style: .default, handler: {(action:UIAlertAction!) in
            self.logout()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    func logout()
    {
        logoutCall()
       
    }
    func logoutCall()
    {
       
            Helper.showLoadingAlert(controller: self)
            let token = NSLocalizedString("auth_prefix", comment: "")+" "+Helper.readPref(key:Constants.userToken.userTokenKey)
        
            let header = [
                "Content-Type" : "application/json; charset=utf-8",
                "Authorization" : token
            ]
        
            
            let object = RestClient.postRequest(method:HTTPMethod.post,url: "api/users/logout/",header:header, parameters: nil,completion: { [weak self] data in
                print(data)
                  let controller = ViewPagerLinker.sideMenuBaseController as! UIViewController
                controller.dismiss(animated:true, completion: {
                    Helper.clearUserDefaults()
                    Helper.isLoggedOut=true
                    Helper.startLandingPage()
                })
                
               
           
            })
            
     
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let cell = tableView.cellForRow(at: indexPath)
        if(indexPath.row==0)
        {
            return 120
        }
        else if(indexPath.row==4)
        {
            if(kycStatus == Constants.kycStatusTypes.approved || kycStatus==Constants.kycStatusTypes.rejected)
            {
             return 0
            }
            else{
                 return 50
            }
            
        }
        else{
            return 50
        }
        
        
    }
 
   

}
