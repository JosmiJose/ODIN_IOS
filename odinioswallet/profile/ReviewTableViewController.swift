//
//  PersonalFormTableView.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 11/07/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import CountryPickerView
import SwiftyJSON
struct Item {
    
    var originPage : Int
    var title : String
    var text : String
    
}

class ReviewTableViewController: UITableViewController  {
    var items = [Item]()
func loadItems()
{
    items = [
    Item(originPage: 1, title: NSLocalizedString("first_name",comment:""), text: Helper.readPref(key: Constants.personalInfo.firstNameKey)),
    Item(originPage: 1, title: NSLocalizedString("middle_name",comment:""), text: Helper.readPref(key: Constants.personalInfo.middleNameKey)),
    Item(originPage: 1, title: NSLocalizedString("last_name",comment:""), text: Helper.readPref(key: Constants.personalInfo.lastNameKey)),
    Item(originPage: 1, title: NSLocalizedString("your_dob",comment:""), text: Helper.readPref(key: Constants.personalInfo.birthDayKey)),
    Item(originPage: 1, title: NSLocalizedString("your_gender",comment:""), text: Helper.readPref(key: Constants.personalInfo.genderKey)),
    Item(originPage: 1, title: NSLocalizedString("your_phone_country",comment:""), text: Helper.readPref(key: Constants.personalInfo.phoneCodeKey)),
    Item(originPage: 1, title: NSLocalizedString("your_phone",comment:""), text: Helper.readPref(key: Constants.personalInfo.phoneNumberKey)),
    Item(originPage: 1, title: NSLocalizedString("your_country",comment:""), text: Helper.readPref(key: Constants.ResidentialInfo.countryCodeKey)),
    Item(originPage: 1, title: NSLocalizedString("your_state",comment:""), text: Helper.readPref(key: Constants.ResidentialInfo.stateKey)),
    Item(originPage: 1, title: NSLocalizedString("your_city",comment:""), text: Helper.readPref(key: Constants.ResidentialInfo.cityKey)),
    Item(originPage: 1, title: NSLocalizedString("your_zipcode",comment:""), text: Helper.readPref(key: Constants.ResidentialInfo.zipCodeKey)),
    Item(originPage: 1, title: NSLocalizedString("your_address1",comment:""), text: Helper.readPref(key: Constants.ResidentialInfo.address1Key)),
    Item(originPage: 1, title: NSLocalizedString("your_address2",comment:""), text: Helper.readPref(key: Constants.ResidentialInfo.address2Key)),
    Item(originPage: 1, title: NSLocalizedString("your_purpose_of_action",comment:""), text: Helper.readPref(key: Constants.InvestmentDetails.purposeOfActionsKey)),
    Item(originPage: 1, title: NSLocalizedString("your_planned_investment_range",comment:""), text: Helper.readPref(key:Constants.InvestmentDetails.plannedRangesKey)),
    Item(originPage: 1, title: NSLocalizedString("your_industry",comment:""), text: Helper.readPref(key:Constants.InvestmentDetails.industyKey)),
    Item(originPage: 1, title: NSLocalizedString("your_work_type",comment:""), text: Helper.readPref(key: Constants.InvestmentDetails.workTypeKey)),
    Item(originPage: 1, title: NSLocalizedString("your_tax_id",comment:""), text: Helper.readPref(key: Constants.InvestmentDetails.taxIdKey)),
    Item(originPage: 1, title: NSLocalizedString("your_nationality",comment:""), text: Helper.readPref(key: Constants.ProofOfIdentity.nationalityKey)),
    Item(originPage: 1, title: NSLocalizedString("your_doc_type",comment:""), text: Helper.readPref(key: Constants.ProofOfIdentity.typeOfDocumentKey)),
    Item(originPage: 1, title: NSLocalizedString("your_doc_number",comment:""), text: Helper.readPref(key: Constants.ProofOfIdentity.docNumberKey)),
    Item(originPage: 1, title: NSLocalizedString("your_doc_expiry_date",comment:""), text: Helper.readPref(key: Constants.ProofOfIdentity.expiryDateKey)),
    Item(originPage: 1, title: NSLocalizedString("your_front_image",comment:""), text:""),
    Item(originPage: 1, title: NSLocalizedString("your_back_image",comment:""), text: ""),
    Item(originPage: 1, title: NSLocalizedString("your_selfie_image",comment:""), text: "")
    ]
    }
    override func viewWillAppear(_ animated:Bool)
{
    super.viewWillAppear(animated)
    loadItems()
    self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imageKey = getImageKey(index:indexPath.row)
        if(indexPath.row==22 || indexPath.row == 23 || indexPath.row == 24 )
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! reviewItemImageCell
            self.tableView.rowHeight=90
            
            let item = items[indexPath.row]
            cell.title.text = item.title.uppercased()
            if let imageData = UserDefaults.standard.object(forKey: imageKey),
                let image = UIImage(data: (imageData as! NSData) as Data){
                cell.cellImage.image=image
                // use your image here...
            }
           // cell.details.text = item.text
              return cell
        }
        else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! reviewItemCell
        self.tableView.rowHeight=60
        
        let item = items[indexPath.row]
        cell.title.text = item.title.uppercased()
        cell.details.text = item.text
              return cell
        }
        
      
    }
    func getImageKey(index:Int)->String
    {
        switch(index)
        {
        case 22 :
            return Constants.ProofOfIdentity.frontImageKey
        case 23:
            return Constants.ProofOfIdentity.backImageKey
        case 24:
            return Constants.ProofOfIdentity.selfieImageKey
        default:
            return ""
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func submitUpdates()
    {
      submitKycDetails()
    }
    func submitKycDetails(){
        
        Helper.showLoadingAlert(controller: self)
        let token = NSLocalizedString("auth_prefix", comment: "")+" "+Helper.readPref(key:Constants.userToken.userTokenKey)
        let header = [
             "Content-Type": "application/form-data"
           , "Authorization" : token
        ]
       
        let body=getBody()
        let intBody=getIntBody()
        let frontImage : UIImage = getImage(imageKey: Constants.ProofOfIdentity.frontImageKey)
         let backImage : UIImage = getImage(imageKey: Constants.ProofOfIdentity.backImageKey)
        let selfieImage : UIImage = getImage(imageKey: Constants.ProofOfIdentity.selfieImageKey)
        let object = RestClient.multipartKYCRequest(url: "api/users/details/update/",header:header, parameters: body,numberParameters:intBody,image1:frontImage,image2:backImage,image3:selfieImage,completion: { [weak self] data in
            
            if(data != nil)
            {
                let status = data["status"]
                if(status).boolValue
                {
                    let kycStatus=data["kyc_status"].stringValue
                    Helper.savePref(key:Constants.kycStatus.kycStatusKey, value: kycStatus)
                    let alert = UIAlertController(title:NSLocalizedString("update_profile_success", comment: "") , message:NSLocalizedString("update_profile_success_msg",comment: "") ,preferredStyle: .alert)
                    let acceptAction = UIAlertAction(title: NSLocalizedString("back_to_main", comment: "") , style: .default, handler: { (action) -> Void in
                        // Get 1st TextField's text
                        Helper.backToMainPage()
                    })
                    
                    alert.addAction(acceptAction)
                    self?.dismiss(animated: true)
                    {
                          self?.present(alert, animated: true)
                    }
                  
                }
                else{
                    self?.dismiss(animated: true)
                    {
                         self?.showError(data: data)
                    }
                   
                }
                
            }
            else
            {
                self?.dismiss(animated: true)
                {
                     self?.showError(data: data)
                }
               
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
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message: NSLocalizedString("create_profile_error", comment: ""), controller: self)
        }
    }
    func getBody()->Dictionary<String, String>
    {
    var body = Dictionary<String, String>()
    body["first_name"] = Helper.readPref(key: Constants.personalInfo.firstNameKey)
    body["middle_name"] = Helper.readPref(key: Constants.personalInfo.middleNameKey)
    body["last_name"] = Helper.readPref(key: Constants.personalInfo.lastNameKey)
    body["date_of_birth"] = Helper.readPref(key: Constants.personalInfo.birthDayKey)
    body["nationality"] = Helper.readPref(key: Constants.ProofOfIdentity.nationalityKey)
    body["country_of_residence"] = Helper.readPref(key: Constants.ResidentialInfo.countryCodeKey)
    body["contact_number"] = Helper.readPref(key: Constants.personalInfo.phoneNumberKey)
    body["address_line_1"] = Helper.readPref(key: Constants.ResidentialInfo.address1Key)
    body["address_line_2"] = Helper.readPref(key: Constants.ResidentialInfo.address2Key)
    body["city"] = Helper.readPref(key: Constants.ResidentialInfo.cityKey)
    body["state"] = Helper.readPref(key: Constants.ResidentialInfo.stateKey)
    body["postal_code"] = Helper.readPref(key: Constants.ResidentialInfo.zipCodeKey)
    body["document_type"] = Helper.readPref(key: Constants.ProofOfIdentity.typeOfDocumentKey)
    body["document_number"] = Helper.readPref(key: Constants.ProofOfIdentity.docNumberKey)
    body["gender"] = Helper.readPref(key: Constants.personalInfo.genderKey)
    body["phone_country_code"] = Helper.readPref(key: Constants.personalInfo.phoneCodeKey)
    body["document_expiry"] = Helper.readPref(key: Constants.ProofOfIdentity.expiryDateKey)
    body["contact_number_code"] = Helper.readPref(key: Constants.personalInfo.phoneCodeKey)
    body["tax_id"] = Helper.readPref(key: Constants.InvestmentDetails.taxIdKey)
        
    return body
    }
    func getIntBody()->Dictionary<String, Int>
    {
        var body = Dictionary<String, Int>()
        body["industry"] = Helper.readIntPref(key: Constants.InvestmentDetails.industyValueKey)
        body["work_type"] = Helper.readIntPref(key: Constants.InvestmentDetails.workTypeValueKey)
        body["purpose_of_action"] = Helper.readIntPref(key: Constants.InvestmentDetails.purposeOfActionsValueKey)
        body["planned_investment"] = Helper.readIntPref(key: Constants.InvestmentDetails.plannedRangesValueKey)
       
        return body
    }
    func getImage(imageKey:String)->UIImage
    {
        var image : UIImage?
        let imageData = UserDefaults.standard.object(forKey: imageKey)
        image = UIImage(data: (imageData as! NSData) as Data)
        return image!
    }
 
}
