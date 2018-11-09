//
//  ExchangeTableViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 09/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import DropDown

class ExchangeTableViewController: UITableViewController,UITextFieldDelegate {
    @IBOutlet weak var amount: BCTextField!
    @IBOutlet weak var dropDownArrow: UIButton!
    @IBOutlet weak var rate: UILabel!
     let kycObject:JSON = Helper.getProfileObject()
    var selectedIndex:Int=0
    @IBAction func continueBtn(_ sender: Any) {
        exchangeTokenInit()
    }
    @IBAction func dropDownBtn(_ sender: Any) {
        let dropDown = DropDown()
        
        // The view to which the drop down will appear on
        dropDown.anchorView = dropDownArrow // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        
        dropDown.dataSource = dropDownData
        
        /*** IMPORTANT PART FOR CUSTOM CELLS ***/
        dropDown.cellNib = UINib(nibName: "MyCell", bundle: nil)
        
        dropDown.customCellConfiguration = { (index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MyCell else { return }
            
            // Setup your custom UI components
            cell.suffixLabel.text = item
        
            Helper.setImage(imageView: cell.tokenIcon, imageString: self.dataSources[index].companyLogo!,placeholder: "place_holder")
        
        }
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.setCompany(company: self.dataSources[index],index:index)
            
        }
        // dropDown.width=200
        dropDown.show()
    }
    
    @IBOutlet weak var confirmAmount: BCTextField!
    @IBOutlet weak var moreAboutBtn: UIButton!
    @IBOutlet weak var availableSupply: UILabel!
    @IBOutlet weak var tokenImage: AnimatedImageView!
    @IBOutlet weak var tokenName: UILabel!
    @IBOutlet weak var dashedLine: UIView!
     var dataSources=[Company]()
     var dropDownData=[String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        dashedLine.addDashedLine(strokeColor: UIColor.darkGray, lineWidth: 1)
        getCompanies(showLoading: true)
           amount.delegate = self
        confirmAmount.delegate=self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    func getCompanies(showLoading:Bool)
    {
        if(showLoading)
        {
              Helper.showLoadingAlert(controller: self)
        }
        
        let token = NSLocalizedString("auth_prefix", comment: "")+" "+Helper.readPref(key:Constants.userToken.userTokenKey)
        let header = [
            "Content-Type" : "application/json; charset=utf-8",
            "Authorization" : token
        ]
        
        
        let object = RestClient.postRequest(method:HTTPMethod.get,url: "api/user/activity/company/list/",header:header, parameters: nil,completion: { [weak self] data in
            self?.refreshControl?.endRefreshing()
            if(showLoading)
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
                        self?.appendCompanies(companies: Helper.getCompanies(values: result["values"].arrayValue))
                    }else{
                        let parent=self?.parent as! ExchangeViewController
                        parent.showEmptyMsgLayout(msg: NSLocalizedString("no_current_icos", comment: ""))
                    }
                    
                }
            }
        })
    }
    func appendCompanies(companies:[Company])
    {
        dataSources.removeAll()
        dropDownData.removeAll()
        for company in companies{
            dataSources.append(company)
            dropDownData.append(company.preIcoTicker!)
        }
        
        if(dataSources.count>0)
        {
            setCompany(company: dataSources[0],index: 0)
        }
        else{
            let parent=self.parent as! ExchangeViewController
            parent.showEmptyMsgLayout(msg: NSLocalizedString("no_current_icos", comment: ""))
        }
    }
    @IBAction func amountChanged(_ sender: Any) {
        let amountTxt:String=amount.text!
        let amt=Double(amountTxt)
        let rateValue = 1 / dataSources[selectedIndex].odinEquivalent!;
        if(amt != nil)
        {
        let value = amt!*rateValue
        confirmAmount.text=Helper.getBalanceFormattedString(number: value)
        }else
        {
             confirmAmount.text=""
        }
   
    }
    func setCompany(company:Company,index:Int)
    {
        selectedIndex=index
    
        self.tokenName.text=company.preIcoTicker
        Helper.setImage(imageView:  self.tokenImage, imageString: company.companyLogo!,placeholder: "place_holder")
        let rateValue = 1 / company.odinEquivalent!;
        rate.text="1 ODIN = "+Helper.getBalanceFormattedString(number: rateValue)+" "+company.preIcoTicker!
        if(kycObject["is_subscribed"].boolValue)
        {
            let supply=company.remainSupply!+company.remainPremiumSupply!
            availableSupply.text=NSLocalizedString("available", comment: "")+" "+Helper.getBalanceFormattedString(number: supply)+" "+company.preIcoTicker!
        }
        else{
            availableSupply.text=NSLocalizedString("available", comment: "")+" "+Helper.getBalanceFormattedString(number: company.remainSupply!)+" "+company.preIcoTicker!
        }
        
        moreAboutBtn.setTitle(NSLocalizedString("more_about", comment: "")+" "+company.preIcoTicker!, for: .normal)
        moreAboutBtn.isEnabled=true
        amount.text=""
        confirmAmount.text=""

        
    }
    func exchangeTokenInit()
    {
        let amountTxt=amount.text
        let amountDouble=(amountTxt as! NSString).doubleValue
        let kycObject:JSON = Helper.getProfileObject()
        if((amountTxt?.isEmpty)!||amountDouble<=0)
        {
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("empty_amount", comment: ""), controller: self)
        }else if(amountDouble > kycObject["odinBalance"].doubleValue)
        {
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("not_enough_balance", comment: ""), controller: self)
        }else if(Constants.minEth.minEthValue>kycObject["ethBalance"].doubleValue)
        {
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("not_enough_transaction_fee", comment: ""), controller: self)
        }else{
            TransPinMatchedManager.curTransMode="EXCHANGE"
            Helper.startPinAuth(mode: "VERIFY", delegate: self)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) // No need for semicolon
        if(TransPinMatchedManager.curTransMode == "EXCHANGE" && TransPinMatchedManager.matched)
        {
            TransPinMatchedManager.curTransMode=""
            TransPinMatchedManager.matched=false
            exchangeToken()
        }
    }
    func exchangeToken()
    {
        let authToken = NSLocalizedString("auth_prefix", comment: "")+" "+Helper.readPref(key:Constants.userToken.userTokenKey)
        let token=dataSources[selectedIndex]
        Helper.showLoadingAlert(controller: self)
        let header = [
            "Content-Type" : "application/json; charset=utf-8",
            "Authorization" : authToken
        ]
    
        let body: [String: Any] = [
            "token": token.preIcoTicker,
            "amount": (confirmAmount.text as! NSString).doubleValue,
            "odin_equivalent": (amount.text as! NSString).doubleValue
        ]
     
        let object = RestClient.postRequest(method:HTTPMethod.post,url: "api/user/transaction/purchase/",header:header, parameters: body,completion: { [weak self] data in
            
            if(data != nil)
            {
                let status = data["status"]
                if(status).boolValue
                {
                    let alert = UIAlertController(title:NSLocalizedString("send_token_success", comment: "") , message:data["result"]["message"].stringValue ,preferredStyle: .alert)
                    let acceptAction = UIAlertAction(title: NSLocalizedString("back_to_main", comment: "") , style: .default, handler: { (action) -> Void in
                        Helper.backToMainPage()
                    })
                    
                    alert.addAction(acceptAction)
                    self?.dismiss(animated: true) {
                        self?.present(alert, animated: true)
                    }
                    
                }
                else{
                    self?.dismiss(animated: true) {
                        self?.showError(data: data)
                    }
                    
                }
            }else{
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
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message: NSLocalizedString("exchange_pre_ico_failed", comment: ""), controller: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mySegue" {
            let nextScene = segue.destination as? ICODetailsViewController
            nextScene?.company=dataSources[selectedIndex]
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let dotString = "."
         let ACCEPTABLE_NUMBERS     = "0123456789"
        if let text = textField.text {
            let isDeleteKey = string.isEmpty
            
            if !isDeleteKey {
                if text.contains(dotString) {
                    if text.components(separatedBy: dotString)[1].count == 4 {
                        
                        return false
                        
                    }
                    
                }
                
            }
        }
        
        
        let newLength: Int = textField.text!.characters.count + string.characters.count - range.length
        let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
        let strValid = string.rangeOfCharacter(from: numberOnly) == nil
        return (strValid)
    }
}
