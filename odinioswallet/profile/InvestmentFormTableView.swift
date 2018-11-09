//
//  PersonalFormTableView.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 11/07/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import CountryPickerView
import DropDown
class InvestmentFormTableView: UITableViewController,UITextFieldDelegate  {
    @IBOutlet weak var workTypeLabel: UILabel!
    @IBOutlet weak var purposeLabel: UILabel!
    
    @IBOutlet weak var taxIdField: BCTextField!
    
    @IBOutlet weak var industryLabel: UILabel!
    @IBOutlet weak var plannedLabel: UILabel!
    var purposeSelected : Bool=false
    var plannedSelected : Bool=false
    var industrySelected : Bool=false
    var workSelected :Bool=false
    var purposeSelectedIndex:Int?
    var plannedSelectedIndex:Int?
    var industrySelectedIndex:Int?
    var workTypesSelectedIndex:Int?
    
    
    let actions = [NSLocalizedString("short_term", comment: ""), NSLocalizedString("long_term", comment: ""), NSLocalizedString("ecommerce",comment:"")]
     let plannedRanges = [NSLocalizedString("range1", comment: ""), NSLocalizedString("range2", comment: ""), NSLocalizedString("range3",comment:""),NSLocalizedString("range4",comment:""),NSLocalizedString("range5",comment:"")]
      let industries = [NSLocalizedString("industry1", comment: ""), NSLocalizedString("industry2", comment: ""), NSLocalizedString("industry3",comment:""),NSLocalizedString("industry4",comment:""),NSLocalizedString("industry5",comment:""),NSLocalizedString("industry6", comment: ""), NSLocalizedString("industry7", comment: ""), NSLocalizedString("industry8",comment:""),NSLocalizedString("industry9",comment:""),NSLocalizedString("industry10",comment:""),NSLocalizedString("industry11", comment: ""), NSLocalizedString("industry12", comment: ""), NSLocalizedString("industry13",comment:""),NSLocalizedString("industry14",comment:""),NSLocalizedString("industry15",comment:""),NSLocalizedString("industry16", comment: ""), NSLocalizedString("industry17", comment: ""), NSLocalizedString("industry18",comment:""),NSLocalizedString("industry19",comment:""),NSLocalizedString("industry20",comment:""),NSLocalizedString("industry21",comment:"")]
     let workOptions = [NSLocalizedString("option1", comment: ""), NSLocalizedString("option2", comment: ""), NSLocalizedString("option3",comment:""),NSLocalizedString("option4",comment:""),NSLocalizedString("option5",comment:""),NSLocalizedString("option6",comment:""),NSLocalizedString("option7",comment:"")]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.setUnderlined(textField: taxIdField)
        allowOnlyEnglishChars()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       switch indexPath.row
        {
       case 0 :
        showPurposeOfActions()
       case 1:
        showPlannedRanges()
       case 2:
        showIndustries()
       case 3:
        showWorkOptions()
       default:
        print("non picker cell")
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
    func showPurposeOfActions()
    {
        let dropDown = DropDown()
        dropDown.dataSource = actions
        dropDown.anchorView=purposeLabel
        setSelection(tag: 1,dropDown: dropDown, label: purposeLabel)
       
        dropDown.show()
    }
    func showPlannedRanges()
    {
        let dropDown = DropDown()
        dropDown.dataSource = plannedRanges
        dropDown.anchorView=plannedLabel
        setSelection(tag: 2,dropDown: dropDown, label: plannedLabel)
        dropDown.show()
    }
    func showIndustries()
    {
        let dropDown = DropDown()
        dropDown.dataSource = industries
        dropDown.anchorView=industryLabel
         setSelection(tag: 3,dropDown: dropDown, label: industryLabel)
        dropDown.show()
    }
    func showWorkOptions()
    {
        let dropDown = DropDown()
        dropDown.dataSource = workOptions
        dropDown.anchorView=workTypeLabel
         setSelection(tag: 4,dropDown: dropDown, label: workTypeLabel)
        dropDown.show()
    }
    
    func setSelection(tag:Int,dropDown : DropDown , label :UILabel)
    {
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
        label.text=item
        switch(tag)
        {
        case 1 : self.purposeSelected=true
        self.purposeSelectedIndex=index
        case 2 : self.plannedSelected=true
        self.plannedSelectedIndex=index
        case 3 : self.industrySelected=true
        self.industrySelectedIndex=index
        case 4 : self.workSelected=true
        self.workTypesSelectedIndex=index
        default:
        print("default")
        }
            
        }
    }
    func saveDate(finished: () -> Void)
    {
          Helper.savePref(key: Constants.InvestmentDetails.purposeOfActionsKey, value: purposeLabel.text!)
          Helper.savePref(key: Constants.InvestmentDetails.plannedRangesKey, value: plannedLabel.text!)
          Helper.savePref(key: Constants.InvestmentDetails.industyKey, value: industryLabel.text!)
          Helper.savePref(key: Constants.InvestmentDetails.workTypeKey, value: workTypeLabel.text!)
          Helper.saveIntPref(key: Constants.InvestmentDetails.purposeOfActionsValueKey, value: purposeSelectedIndex!)
          Helper.saveIntPref(key: Constants.InvestmentDetails.plannedRangesValueKey, value: plannedSelectedIndex!)
          Helper.saveIntPref(key: Constants.InvestmentDetails.industyValueKey, value: industrySelectedIndex!)
          Helper.saveIntPref(key: Constants.InvestmentDetails.workTypeValueKey, value: workTypesSelectedIndex!)
          Helper.savePref(key: Constants.InvestmentDetails.taxIdKey, value: taxIdField.text!)
          finished()
    }
    func isReadyToSubmit()->Bool
    {
        if(taxIdField.text?.isEmpty)!
        {
            return false
        }else if(!purposeSelected)
        {
            return false
        }
        else if(!plannedSelected)
        {
            return false
        }
        else if(!industrySelected)
        {
            return false
        }
        else if(!workSelected)
        {
            return false
        }
        else{
            return true
        }
        
        
        
    }
    func allowOnlyEnglishChars()
    {
        taxIdField.keyboardType = UIKeyboardType.asciiCapable
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
}
