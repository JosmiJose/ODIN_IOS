//
//  PersonalFormTableView.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 11/07/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import CountryPickerView
class ResedentialFormTableView: UITableViewController,UITextFieldDelegate,CountryPickerViewDelegate  {

    @IBOutlet weak var stateField: BCTextField!
    @IBOutlet weak var CPP: CountryPickerView!
    @IBOutlet weak var zipField: BCTextField!
    
    @IBOutlet weak var address2Field: BCTextField!
    @IBOutlet weak var address1Field: BCTextField!
    @IBOutlet weak var cityField: BCTextField!
    let ACCEPTABLE_CITY_STATE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_ "
     let ACCEPTABLE_Zip_Code_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    let ACCEPTABLE_Address_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_,.- #"
    override func viewDidLoad() {
        super.viewDidLoad()
        setInputUnderlined()
        CPP.showCountryCodeInView = true
        CPP.showPhoneCodeInView = false
        CPP.setCountryByCode("JP")
        let country = CPP.selectedCountry
        CPP.countryDetailsLabel.text=country.name
        CPP.delegate=self
        CPP.center = self.view.center
        allowOnlyEnglishChars()
    }
    func allowOnlyEnglishChars()
    {
        stateField.keyboardType = UIKeyboardType.asciiCapable
        cityField.keyboardType = UIKeyboardType.asciiCapable
        address1Field.keyboardType = UIKeyboardType.asciiCapable
        address2Field.keyboardType = UIKeyboardType.asciiCapable
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var status = true
        let cs : CharacterSet?
         var maxLength=0
        if(textField.tag==0 || textField.tag==1)
        {
            cs = NSCharacterSet(charactersIn: ACCEPTABLE_CITY_STATE_CHARACTERS).inverted as NSCharacterSet as CharacterSet
            let filtered = string.components(separatedBy: cs as! CharacterSet).joined(separator: "")
            
            status = string == filtered
            maxLength = 50
            
        }else if (textField.tag==2) {
            cs = NSCharacterSet(charactersIn: ACCEPTABLE_Zip_Code_CHARACTERS).inverted as NSCharacterSet as CharacterSet
            let filtered = string.components(separatedBy: cs as! CharacterSet).joined(separator: "")
            
            status = string == filtered
            maxLength = 15
        }else if (textField.tag==3 || textField.tag==4) {
            cs = NSCharacterSet(charactersIn: ACCEPTABLE_Address_CHARACTERS).inverted as NSCharacterSet as CharacterSet
            let filtered = string.components(separatedBy: cs as! CharacterSet).joined(separator: "")
            
              status = string == filtered
              maxLength = 50
        }
        
      
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        if(newString.length > maxLength)
        {
            status=false
        }
        
        return status
        
      
    }
    
    func setInputUnderlined()
    {
        Helper.setUnderlined(textField: stateField)
        Helper.setUnderlined(textField: zipField)
        Helper.setUnderlined(textField: address2Field)
        Helper.setUnderlined(textField: address1Field)
        Helper.setUnderlined(textField: cityField)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func saveDate(finished: () -> Void)
    {
        Helper.savePref(key: Constants.ResidentialInfo.stateKey, value: stateField.text!)
        Helper.savePref(key: Constants.ResidentialInfo.cityKey, value: cityField.text!)
        Helper.savePref(key: Constants.ResidentialInfo.zipCodeKey, value: zipField.text!)
        Helper.savePref(key: Constants.ResidentialInfo.address1Key, value: address1Field.text!)
        
         Helper.savePref(key: Constants.ResidentialInfo.address2Key, value: address2Field.text!)
        
        Helper.savePref(key: Constants.ResidentialInfo.countryCodeKey, value: CPP.selectedCountry.code)
        finished()
      
        
    }
    func isReadyToSubmit()->Bool
    {
        if(stateField.text?.isEmpty)!
        {
            return false
        }else if(zipField.text?.isEmpty)!
        {
            return false
        }
        else if(cityField.text?.isEmpty)!
        {
            return false
        }
        else if(address1Field.text?.isEmpty)!
        {
            return false
        }
        else if(address2Field.text?.isEmpty)!
        {
            return false
        }else{
            return true
        }
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print("returned textfield")
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
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
           CPP.countryDetailsLabel.text=country.name
    }

}
