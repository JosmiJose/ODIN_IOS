//
//  sendTableViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 06/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON
import Kingfisher
import Alamofire
class sendTableViewController: UITableViewController ,UITextFieldDelegate{
    var dataSources=[Token]()
    var dropDownData=[String]()
     let dropDown = DropDown()
    
    @IBAction func sendToken(_ sender: Any) {
    sendTokenInit()
    }
    func sendTokenInit()
    {
        let addressTxt=address.text
        let amountTxt=amount.text
        var mySubstring = addressTxt?.prefix(2)
        let prefixEqual=mySubstring=="0x"
        let countEqual=addressTxt?.count==42
        let amountDouble=(amountTxt as! NSString).doubleValue
        let kycObject:JSON = Helper.getProfileObject()
        let val=kycObject["ethBalance"].doubleValue - amountDouble
        if(!prefixEqual || !countEqual)
        {
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("invalid_address", comment: ""), controller: self)
        }else if(addressTxt?.isEmpty)!
        {
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("empty_address", comment: ""), controller: self)
        }else if(addressTxt?.isEmpty)!
        {
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("empty_address", comment: ""), controller: self)
        }else if((amountTxt?.isEmpty)!||amountDouble<=0)
        {
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("empty_amount", comment: ""), controller: self)
        }else if(amountDouble > dataSources[selectedIndex].holdings as! Double)
        {
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("not_enough_balance", comment: ""), controller: self)
        }else if(self.tokenName.text=="Eth" && val<Constants.minEth.minEthValue)
        {
         

                Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("not_enough_balance", comment: ""), controller: self)

           
        }
        else if(Constants.minEth.minEthValue>kycObject["ethBalance"].doubleValue)
        {
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("not_enough_transaction_fee", comment: ""), controller: self)
        }else{
            TransPinMatchedManager.curTransMode="SEND"
            Helper.startPinAuth(mode: "VERIFY", delegate: self)
        }
    }
    func sendToken()
    {
        let authToken = NSLocalizedString("auth_prefix", comment: "")+" "+Helper.readPref(key:Constants.userToken.userTokenKey)
        let token=dataSources[selectedIndex]
        Helper.showLoadingAlert(controller: self)
        let header = [
            "Content-Type" : "application/json; charset=utf-8",
            "Authorization" : authToken
        ]
        let body: [String: Any] = [
            "token": token.tokenName,
            "amount": (amount.text as! NSString).doubleValue,
            "toAddress": address.text,
            "token_equivalent": token.odinEquivalent
        ]
        
        let object = RestClient.postRequest(method:HTTPMethod.post,url: "api/user/transaction/sendToken/",header:header, parameters: body,completion: { [weak self] data in
           
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
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message: NSLocalizedString("send_token_error", comment: ""), controller: self)
        }
    }
    @IBOutlet weak var address: BCTextField!
    @IBOutlet weak var amount: BCTextField!
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var tokenName: UILabel!
    @IBOutlet weak var dropDownArrow: UIButton!
    var selectedIndex:Int=0
    
    @IBAction func showTokenList(_ sender: Any) {
       
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
            if(item=="ODIN")
            {
                cell.tokenIcon.image=UIImage(named:"mascot_landing")
            }
            else if(item=="Eth")
            {
                cell.tokenIcon.image=UIImage(named:"ether")
            }
            else{
                Helper.setImage(imageView: cell.tokenIcon, imageString: self.dataSources[index].tokenImage!,placeholder: "place_holder")
            }
        }
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.resetFields()
            self.setSelection(item: self.dataSources[index].tokenName!, index: index)
            
        }
       // dropDown.width=200
        dropDown.show()
    }
    func resetFields()
    {
        self.address.text=""
        self.amount.text=""
    }
    @IBAction func setMax(_ sender: Any) {
        if(dataSources.count>0)
        {
            
            let num=(dataSources[selectedIndex].holdings?.description as! NSString).doubleValue
            
            amount.text=String(num.truncate(places:4 ))
        }
    }
    func setSelection(item:String,index:Int)
    {
        selectedIndex=index
        if(item=="odin")
        {
           selectOdin()
        }else if(item=="eth"){
           selectEther()
        }else{
            self.tokenName.text=self.dataSources[index].tokenName
            Helper.setImage(imageView:  self.tokenImage, imageString: self.dataSources[index].tokenImage!,placeholder: "place_holder")
        }
    }
   func selectOdin()
    {
    self.tokenName.text="ODIN"
    self.tokenImage.image=UIImage(named:"mascot_landing")
    }
    func selectEther()
    {
        self.tokenName.text="Eth"
        self.tokenImage.image=UIImage(named:"ether")
    }
    func getOdinToken(odinBalance:Double)->Token
    {
        let token = Token(decimals: 0,isDbToken:false,tokenName:"odin",tokenImage:"",holdings:odinBalance,tokenLongName:"ODIN",odinEquivalent:1.0)
        return token
    }
    func getEtherToken(etherBalance:Double)->Token
    {
        let token = Token(decimals: 18,isDbToken:false,tokenName:"eth",tokenImage:"",holdings:etherBalance,tokenLongName:"Ethereum",odinEquivalent:0.0)
        return token
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        amount.delegate = self
      
    }
    func initData()
    {
        dataSources.removeAll()
        dropDownData.removeAll()
        let kycObject:JSON = Helper.getProfileObject()
        if(kycObject["odinBalance"]>0)
        {
            dropDownData.append("ODIN")
            dataSources.append(getOdinToken(odinBalance: kycObject["odinBalance"].doubleValue))
        }
        if(kycObject["ethBalance"]>0)
        {
            dropDownData.append("Eth")
            dataSources.append(getEtherToken(etherBalance: kycObject["ethBalance"].doubleValue))
        }
        
        if(dataSources.count>0)
        {
            setSelection(item: dataSources[0].tokenName!, index:0 )
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func appendTokens(tokens:[Token])
    {
        initData()
        for token in tokens{
            if(!token.isDbToken!)
            {
            dataSources.append(token)
            dropDownData.append(token.tokenName!)
            }
        }
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = self.tableView.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) // No need for semicolon
        if(TransPinMatchedManager.curTransMode == "SEND" && TransPinMatchedManager.matched)
        {
            TransPinMatchedManager.curTransMode=""
            TransPinMatchedManager.matched=false
            sendToken()
        }
    }
    func setQRCodeResult(result:String)
    {
        let kycObject:JSON = Helper.getProfileObject()
        var addressTxt=""
      
        let modified = result.replacingOccurrences(of: " ", with: "")
        let dataToConvert = modified.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        var jsonResult:JSON?
        do {
            jsonResult = try JSON(data: dataToConvert!)
        } catch {
            // handle error
        }
        if(jsonResult != nil)
        {
        if(jsonResult!["to"].exists())
        {
           
            if(kycObject["odinBalance"]>0)
            {
            addressTxt=jsonResult!["to"].stringValue
            selectOdin()
            selectedIndex=0
            }
      
        }
        }else{
       
             if(kycObject["ethBalance"]>0)
             {
            selectedIndex=1
            addressTxt=modified
            selectEther()
            }
        
        }
    
        self.address.text=addressTxt
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
       
        let dotString = "."
        
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
         let ACCEPTABLE_NUMBERS     = "0123456789"
         if(self.tokenName.text=="ODIN")
         {
            let newLength: Int = textField.text!.characters.count + string.characters.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
            let strValid = string.rangeOfCharacter(from: numberOnly) == nil
            return (strValid)
        }else
         {
            return true
        }
       
    }
}
extension Double
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
