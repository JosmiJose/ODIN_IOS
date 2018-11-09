//
//  Helper.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 27/06/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//
import UIKit
import SwiftyJSON
import AVFoundation
import QRCodeReader
import Navajo_Swift
import SideMenu
class Helper{
    static var isLoggedOut = false
    static  var balanceMode = 1
    static func showErrorAlert(title:String,message:String,controller:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
        
        controller.present(alert, animated: true)
    }
    
    static func showTwoButtonsAlert(title:String,message:String,controller:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
        
        controller.present(alert, animated: true)
    }
   
    static func showLoadingAlert(controller:UIViewController)
    {
        let alert = UIAlertController(title: nil, message: NSLocalizedString("loading", comment: ""), preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        controller.present(alert, animated: true, completion: nil)
    }
    static func isValidEmail(email:String?) -> Bool {
        
        guard email != nil else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    static func saveIntPref(key:String,value:Int)
    {
        let preferences = UserDefaults.standard
        
        preferences.set(value, forKey: key)
        
        preferences.synchronize()
    }
    static func savePref(key:String,value:String)
    {
        let preferences = UserDefaults.standard
        
        preferences.set(value, forKey: key)
        
        preferences.synchronize()
    }
    
    static func readIntPref(key:String) -> Int
    {
        let preferences = UserDefaults.standard
        var value=0
        if preferences.object(forKey: key) == nil {
            //  Doesn't exist
        } else {
            value = preferences.integer(forKey: key)
        }
        
        return value
    }
    static func readPref(key:String) -> String
    {
        let preferences = UserDefaults.standard
        var value=""
        if preferences.object(forKey: key) == nil {
            //  Doesn't exist
        } else {
            value = preferences.string(forKey: key)!
        }
        
        return value
    }
    static func saveBoolPref(key:String,value:Bool)
    {
        let preferences = UserDefaults.standard
        
        preferences.set(value, forKey: key)
        
        preferences.synchronize()
    }
    static func readBoolPref(key:String) -> Bool
    {
        let preferences = UserDefaults.standard
        var value : Bool = false
        if preferences.object(forKey: key) == nil {
            //  Doesn't exist
        } else {
            value = preferences.bool(forKey: key)
        }
        
        return value
    }
    static func clearUserDefaults()
    {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    static func getJsonFromString(data:String)->JSON!
    {
        var obj:JSON=nil
        if let data = data.data(using: .utf8) {
            if let jsonObject = try? JSON(data: data) {
                obj=jsonObject
            }
        }
        return obj
    }
    static func getBalanceFormattedString(number:Double)->String
    {
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = NumberFormatter.Style.decimal
        percentFormatter.minimumFractionDigits = 2
        percentFormatter.maximumFractionDigits = 4
        let myString1 = percentFormatter.string(for: number)
        return myString1!
    }
    static func setGenericBalance(profile:JSON,balanceButton:UIButton)
{
    let odinBalance=profile["odinBalance"].doubleValue
    let ethBalance=profile["ethBalance"].doubleValue
    balanceButton.titleLabel?.adjustsFontSizeToFitWidth = true;
    if(Helper.balanceMode==1)
    {
        balanceButton.setTitle("ODIN "+Helper.getBalanceFormattedString(number: odinBalance), for: .normal)
    }
    else{
        balanceButton.setTitle("ETHER "+Helper.getBalanceFormattedString(number: ethBalance), for: .normal)
    }
    }
    static func getProfileObject()->JSON
    {
        return Helper.getJsonFromString(data: Helper.readPref(key: Constants.kycStatus.kycObjectKey))
    }
    static func getTokens()->JSON
    {
        return Helper.getJsonFromString(data: Helper.readPref(key: Constants.tokens.tokensKey))
    }
    static func startPinAuth(mode:String,delegate:UIViewController)
    {
            let storyboard = UIStoryboard(name: "PinAuth", bundle: nil)
            let controller = storyboard.instantiateInitialViewController() as! PinViewController
            controller.mode=mode
            delegate.present(controller, animated: true, completion: nil)
    }
    static func backToMainPage() {
        let storyboard = UIStoryboard(name: "App", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "appInitial") as! UIViewController
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    static func backToLandingPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "mainInitial") as! UIViewController
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    static func getTokens(values:[JSON])->[Token]
    {
        var tokens=[Token]()
        for value in values {
            let token = Token(decimals: value["decimals"].intValue,isDbToken:value["is_db_token"].boolValue,tokenName:value["token_name"].stringValue,tokenImage:value["token_img"].stringValue,holdings:value["holdings"].doubleValue,tokenLongName:value["token_long_name"].stringValue,odinEquivalent:value["odin_equivalent"].doubleValue)
            
            tokens.append(token)
        }
        return tokens
        
    }
    static func getHistories(values:[JSON])->[HistoryItem]
    {
        var histories=[HistoryItem]()
        for value in values {
            let history = HistoryItem(id: value["id"].intValue,isDbToken:value["is_db_token"].boolValue,txHash:value["tx_hash"].stringValue,token:value["token"].stringValue,amount:value["amount"].doubleValue,toAddress:value["toAddress"].stringValue,odinEquivalent:value["odin_token_equivalent"].doubleValue,txTimestamp:value["tx_timestamp"].stringValue,fromAddress:value["fromAddress"].stringValue,isPremium:value["is_premium"].boolValue,statusMsg:value["status_msg"].stringValue)
               histories.append(history)
        }
        
        return histories
        
    }
    static func getPointsHistory(values:[JSON])->[pointsHistory]
    {
        var histories=[pointsHistory]()
        for value in values {
            let history = pointsHistory(userId: value["user_id"].intValue,pointDate:value["point_date"].stringValue,pointsAdded: value["point_added"].intValue,pointsHistoryId: value["points_history_id"].intValue)
            
            histories.append(history)
        }
        
        return histories
        
    }
    static func getMemberHistory(values:[JSON])->[memberHistory]
    {
        var histories=[memberHistory]()
        for value in values {
            let history = memberHistory(subscriptionId: value["subscription_id"].intValue,subscriptionDate:value["subscription_date"].stringValue,userId: value["user_id"].intValue,subscriptionEndDate:value["subscription_end_date"].stringValue,usersubscriptionId: value["user_subscription_id"].intValue,pointsUsed: value["points_used"].intValue)
            
            histories.append(history)
        }
        
        return histories
        
    }
    static func getPackageItems(values:[JSON])->[packageItem]
    {
        var items=[packageItem]()
        for value in values {
            let item = packageItem(managerId: value["manager_id"].intValue,updatedAt:value["updated_at"].stringValue,noOfDays: value["no_of_days"].intValue,subscribe_id: value["subscribe_id"].intValue,subscribtionDetails:value["subscription_detail"].stringValue,deletedAt:value["deleted_at"].stringValue,points: value["points"].intValue)
            
            items.append(item)
        }
        return items
        
    }
    static func getNews(values:[JSON])->[newsItem]
    {
        var items=[newsItem]()
        for value in values {
            let item = newsItem(updatedAt:value["updated_at"].stringValue,body:value["body"].stringValue,uploadImage:value["upload_image"].stringValue,newFlag:value["new_flag"].stringValue,createdAt:value["created_at"].stringValue,title:value["title"].stringValue,desc:value["description"].stringValue,subscriptionId:value["subscribe_id"].intValue,newsId:value["news_id"].intValue)
            
            items.append(item)
        }
        
        return items
        
    }
    static func getCompanies(values:[JSON])->[Company]
    {
        var companies=[Company]()
        
        for value in values {
            var teamMembers=[teamMember]()
            var memberJson:[JSON]=value["team_details"].arrayValue
            for member in memberJson
            {
                let teamMemberObject=teamMember(picture:member["picture"].stringValue,companyId:member["company_id"].intValue,employeeName:member["employee_name"].stringValue,id:member["id"].intValue,about:member["about"].stringValue,linkedInProfile:member["linkedin_profile"].stringValue,nationality:member["nationality"].stringValue)
                teamMembers.append(teamMemberObject)
            }
            let company = Company(totalSupply: value["total_supply"].doubleValue,companyId: value["company_id"].intValue,permiumSupply: value["premium_supply"].doubleValue,dateOfTokenRelease:value["date_of_token_release"].stringValue,industryType:value["industry_type"].stringValue,noOfDecimals: value["no_of_decimals"].intValue,icoStatus:value["ico_status"].stringValue,whitePaper:value["white_paper"].stringValue,companyName:value["company_name"].stringValue,remainSupply: value["remain_supply"].doubleValue,companyLogo:value["company_logo"].stringValue,walletId:value["wallet_id"].stringValue,contractSourceCode:value["contract_source_code"].stringValue,odinEquivalent:value["odin_equivalent"].doubleValue,companyReview:value["company_review"].stringValue,companyUserId:value["company_user_id"].intValue,updatedAt:value["updated_at"].stringValue,preIcoName:value["pre_ico_name"].stringValue,website:value["website"].stringValue,establishedDate:value["established_date"].stringValue,companyOverview:value["company_overview"].stringValue,contractAbi:value["contract_abi"].stringValue,contractAddress:value["contract_address"].stringValue,companyRating:value["company_rating"].intValue,icoStartDate:value["ico_start_date"].stringValue,remainPremiumSupply:value["remain_premium_supply"].doubleValue,createdAt:value["created_at"].stringValue,preIcoTicker:value["pre_ico_ticker"].stringValue,icoEndDate:value["ico_end_date"].stringValue,odinHoldings:value["odin_holdings"].doubleValue,deletedAt:value["deleted_at"].stringValue,members:teamMembers)
            
           
            companies.append(company)
        }
        return companies
        
    }
    static func setImage(imageView:UIImageView,imageString:String,placeholder:String)
    {
        let image = UIImage(named: placeholder)
        var url:URL?
        if(!(imageString.isEmpty))
        {
            url = URL(string:imageString)
        }
        else{
            url = URL(string:"")
        }
        
        imageView.kf.setImage(with: url,placeholder: image)
    }
    static func getFormattedDate(date:String)->String
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MM-yyyy"
        
        if let date = dateFormatterGet.date(from: date){
            return(dateFormatterPrint.string(from: date))
        }
        else {
            return("Wrong Formate")
        }
    }
    static func setUnderlined(textField:UITextField)
    {
        textField.underlined()
    }
    static func getReaderVC()->QRCodeReaderViewController
    {
        var readerVC: QRCodeReaderViewController = {
            let builder = QRCodeReaderViewControllerBuilder {
                $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            }
            
            return QRCodeReaderViewController(builder: builder)
        }()
        return readerVC
    }
   
    static func captureQrCode(controller:UIViewController)
    {
        let readerVC:QRCodeReaderViewController=Helper.getReaderVC()
        readerVC.delegate = controller as! QRCodeReaderViewControllerDelegate
        
        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            let main :AppMainViewController = controller as! AppMainViewController
            if(result != nil)
            {
            main.processQrCodeResult(result: (result?.value)!)
            }

        }
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        controller.present(readerVC, animated: true, completion: nil)
    }
    static func openInternalUrl(path:String)
    {
        let url=K.ProductionServer.baseURL+path
        UIApplication.shared.openURL(URL(string:url)!)
    }
    static func decidePasswordStrength(password:String,passwordInputFeedback:UILabel,inputProgressView:UIProgressView)->Int
    {
        var passwordStrength=0
        let strength = Navajo.strength(ofPassword: password)
        switch strength {
        case .veryWeak:
            passwordInputFeedback.text="Very Weak";
            inputProgressView.progressTintColor=UIColor.red
            inputProgressView.setProgress(0.20, animated: false)
            passwordStrength=1
        case .weak:
            passwordInputFeedback.text="Weak";
            inputProgressView.setProgress(0.40, animated: false)
            inputProgressView.progressTintColor=UIColor.orange
            passwordStrength=2
        case .reasonable:
            passwordInputFeedback.text="Reasonable";
            inputProgressView.setProgress(0.60, animated: false)
            inputProgressView.progressTintColor=UIColor.blue
            passwordStrength=3
        case .strong:
            passwordInputFeedback.text="Strong";
            inputProgressView.setProgress(0.80, animated: false)
            inputProgressView.progressTintColor=UIColor.cyan
            passwordStrength=4
        case .veryStrong:
            passwordInputFeedback.text="Very Strong";
            inputProgressView.setProgress(1, animated: false)
            inputProgressView.progressTintColor=UIColor.green
            passwordStrength=5
            
           
        }
         return passwordStrength
    }
    static func openGenericWebview(url:String,controller:UIViewController,title:String)
    {
          let urlString=K.ProductionServer.baseURL+url
        let storyboard = UIStoryboard(name: "settings", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "genericWebview") as! GenericWebviewNavController
        viewController.url=urlString
         viewController.pageTitle=title
        controller.present(viewController, animated: false)
    }
    static func showSlideMenu(storyBoard:UIStoryboard,controller:String)
    {
        let menuLeftNavigationController = storyBoard.instantiateViewController(withIdentifier: controller) as! UISideMenuNavigationController
         SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
    }
    static func startLandingPage()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "mainInitial")
        
        
        UIApplication.shared.keyWindow?.rootViewController = newViewController
       
    }
}
extension UITextField {
    
    func underlined(){
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
}
