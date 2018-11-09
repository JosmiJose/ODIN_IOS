//
//  PersonalFormTableView.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 11/07/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import CountryPickerView
class PersonalFormTableView: UITableViewController,UITextFieldDelegate  {
   
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var middleName: BCTextField!
    @IBOutlet weak var firstName: BCTextField!
    @IBOutlet weak var genderSwitch: UISegmentedControl!
    @IBOutlet weak var LastName: BCTextField!
    @IBOutlet weak var PhoneNumberField: BCTextField!
    var dateSet:Bool = false
    var cp = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
    @IBAction func textChanged(_ sender: Any) {
       
    }
    var showDate:Bool=false
   
    @IBAction func dateChanged(_ sender: Any) {
       setDate()
    }
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var status = true
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        status = string == filtered
        let maxLength = 50
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        if(newString.length > maxLength)
        {
            status=false
        }
  
        return status
    }
    func setDate()
    {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var strDate = dateFormatter.string(from: birthDatePicker.date)
        self.dateLabel.text = strDate
        dateSet=true
    }
    @IBOutlet weak var dateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setDateLimits()
        setInputUnderlined()
        firstName.becomeFirstResponder()
        PhoneNumberField.leftView = cp
        PhoneNumberField.leftViewMode = .always
        cp.setCountryByCode("JP")
        allowOnlyEnglishChars()
      
    }
    func setDateLimits()
    {
        let currentDate = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = -15
        let maxDate = calendar.date(byAdding: dateComponents, to: currentDate)
        birthDatePicker.maximumDate=maxDate
    }
    func allowOnlyEnglishChars()
    {
          firstName.keyboardType = UIKeyboardType.asciiCapable
          middleName.keyboardType = UIKeyboardType.asciiCapable
          LastName.keyboardType = UIKeyboardType.asciiCapable
    }
    func setInputUnderlined()
    {
        Helper.setUnderlined(textField: middleName)
        Helper.setUnderlined(textField: firstName)
        Helper.setUnderlined(textField: LastName)
        Helper.setUnderlined(textField: PhoneNumberField)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 3:
            if(showDate)
            {
                showDate=false
            }else{
                showDate=true
            }
        
            self.tableView.reloadData()
             setDate()
            
        default:
            print("default")
        }
    }
    func saveDate(finished: () -> Void)
    {
        Helper.savePref(key: Constants.personalInfo.firstNameKey, value: firstName.text!)
        Helper.savePref(key: Constants.personalInfo.middleNameKey, value: middleName.text!)
        Helper.savePref(key: Constants.personalInfo.lastNameKey, value: LastName.text!)
        Helper.savePref(key: Constants.personalInfo.birthDayKey, value: dateLabel.text!)
        
        if(genderSwitch.selectedSegmentIndex==0)
        {
         Helper.savePref(key: Constants.personalInfo.genderKey, value: "Male")
        }
        else{
              Helper.savePref(key: Constants.personalInfo.genderKey, value: "Female")
        }
        
        Helper.savePref(key: Constants.personalInfo.phoneCodeKey, value: cp.selectedCountry.code)
        Helper.savePref(key: Constants.personalInfo.phoneNumberKey, value: PhoneNumberField.text!)
        finished()
    }
    func isReadyToSubmit()->Bool
    {
        if(firstName.text?.isEmpty)!
        {
          return false
        }
        else if(LastName.text?.isEmpty)!
        {
            return false
        }
        else if(!dateSet)
        {
            return false
        }
        else if(PhoneNumberField.text?.isEmpty)!
        {
            return false
        }else{
           return true
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let cell = tableView.cellForRow(at: indexPath)
        if(indexPath.row==4)
        {
            if(showDate)
            {
                return 140
            }
            else{
            return 0
            }
        }
        else{
            return 60
        }
        
        
    }
}
