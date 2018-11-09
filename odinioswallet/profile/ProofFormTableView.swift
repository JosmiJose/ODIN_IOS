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
class ProofFormTableView: UITableViewController,UITextFieldDelegate,CountryPickerViewDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var documentLabel: UILabel!
    var showDate:Bool=false
    var dateSet:Bool=false
    var frontImageHolder:UIImage?
    var backImageHolder:UIImage?
    var selfieImageHolder:UIImage?
    var dateIsMandatory:Bool=false
    @IBAction func dateChanged(_ sender: Any) {
         setDate()
    }
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var status = true
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        status = string == filtered
        let maxLength = 30
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
        var strDate = dateFormatter.string(from: expiryDatePicker.date)
        self.dateLabel.text = strDate
        dateSet=true
    }
    @IBOutlet weak var expiryDatePicker: UIDatePicker!

    var imageMode=0
      var picker = UIImagePickerController();
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row==3)
        {
            let dropDown = DropDown()
            dropDown.dataSource = [NSLocalizedString("id", comment: ""), NSLocalizedString("passport", comment: ""), NSLocalizedString("license",comment:"")]
            dropDown.anchorView=documentLabel
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.documentLabel.text=item
                if(item==NSLocalizedString("passport", comment: "") || item==NSLocalizedString("license",comment:""))
                {
                    self.dateIsMandatory=true
                     self.tableView.reloadData()
                }else
                {
                     self.dateIsMandatory=false
                     self.tableView.reloadData()
                }
    
            }
            dropDown.show()
        }
            
        else if(indexPath.row==5)
        {
            if(showDate)
            {
                showDate=false
            }else{
                showDate=true
            }
            
            self.tableView.reloadData()
            setDate()
        }
        else if(indexPath.row==7)
        {
          imageMode=1
          showGuidelinesAlert()
        }
        else if(indexPath.row==9)
        {
            imageMode=2
           showGuidelinesAlert()
        }
        else if(indexPath.row==11)
        {
            imageMode=3
            showGuidelinesAlert()
        }
    }
    func showGuidelinesAlert()
    {
        let alert = UIAlertController(title:NSLocalizedString("upload_photo_guidlines_title", comment: "") , message:NSLocalizedString("upload_photo_guidlines",comment: "") ,preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: NSLocalizedString("continue", comment: "") , style: .default, handler: { (action) -> Void in
            
                   self.showPhotoSelection()
            
         

        })
        let continueAction = UIAlertAction(title: NSLocalizedString("cancel", comment: "") , style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            
        })
        alert.addAction(continueAction)
        alert.addAction(acceptAction)
      
        self.present(alert, animated: true)
    }
    func showPhotoSelection()
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        //alert.isModalInPopover = true
    
        let pickAction = UIAlertAction(title: NSLocalizedString("action_photo_pick", comment: ""), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
              self.openGallary()
        })
        alert.addAction(pickAction)
        let takeAction = UIAlertAction(title: NSLocalizedString("action_photo_take", comment: ""), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openCamera()
        })
       
        alert.addAction(takeAction)
         let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .default, handler: nil)
        alert.addAction(cancelAction)
       
          alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect =  CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        alert.preferredContentSize=CGSize(width: 400, height: 200)
        DispatchQueue.main.async {
           self.present(alert, animated: true, completion: nil)
        }
        
       
    }
 
    func openCamera(){
    
            picker.delegate = self
            picker.sourceType = .camera;
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
    
    }
    func openGallary(){
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)
    }
    @IBOutlet weak var selfieImage: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var frontImage: UIImageView!
    @IBAction func showSelfieImage(_ sender: Any) {
        shouldHideSelfieImage=false
        self.tableView.reloadData()
    }
    @IBOutlet weak var selfieImageCell: UITableViewCell!
    @IBOutlet weak var backImageCell: UITableViewCell!
    @IBOutlet weak var frontImageCell: UITableViewCell!
    var shouldHideFrontImage=true;
    var shouldHideBackImage=true;
    var shouldHideSelfieImage=true;
  
   
    @IBOutlet weak var documentNumberField: BCTextField!
    
    @IBOutlet weak var CPP: CountryPickerView!
    
   
   
    func showFrontImage(image:UIImage)
    {
        frontImage.image=image
        shouldHideFrontImage=false
        self.tableView.reloadData()
    }
    func showBackImage(image:UIImage)
    {
        backImage.image=image
        shouldHideBackImage=false
        self.tableView.reloadData()
    }
    func showSelfieImage(image:UIImage)
    {
        selfieImage.image=image
        shouldHideSelfieImage=false
        self.tableView.reloadData()
    }
    @IBAction func showBackImage(_ sender: Any) {
        shouldHideBackImage=false
        self.tableView.reloadData()
    }
    @IBOutlet weak var frontImagePlaceHolder: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.setUnderlined(textField: documentNumberField)
        CPP.showCountryCodeInView = true
        CPP.showPhoneCodeInView = false
        CPP.setCountryByCode("JP")
        let country = CPP.selectedCountry
        CPP.countryDetailsLabel.text=country.name
        CPP.delegate=self
        CPP.center = self.view.center
        // Initialize Data
        allowOnlyEnglishChars()
      
    }
    func allowOnlyEnglishChars()
    {
        documentNumberField.keyboardType = UIKeyboardType.asciiCapable
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let cell = tableView.cellForRow(at: indexPath)
            if(indexPath.row==5 && !self.dateIsMandatory)
            {
                return 0
            }
                if(indexPath.row==0||indexPath.row==2)
                {
                    return 40
                 }
        else if(indexPath.row==6)
        {
            if(showDate)
            {
                return 140
            }
            else{
                return 0
            }
        }
                else if(indexPath.row==8)
                {
                    if(shouldHideFrontImage)
                    {
                        return 0
                    }
                    else{
                    return 150
                    }
                }
                else if(indexPath.row==10)
                {
                    if(shouldHideBackImage)
                    {
                        return 0
                    }
                    else{
                        return 150
                    }
                }
                else if(indexPath.row==12)
                {
                    if(shouldHideSelfieImage)
                    {
                        return 0
                    }
                    else{
                        return 150
                    }
                }
        else{
            return 60
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
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
           CPP.countryDetailsLabel.text=country.name
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if(imageMode==1)
        {
        frontImageHolder=(info[UIImagePickerControllerOriginalImage] as? UIImage!)!
              saveImage(image:frontImageHolder!,key:Constants.ProofOfIdentity.frontImageKey)
            showFrontImage(image: frontImageHolder!)
        }else if(imageMode==2)
        {
            backImageHolder=(info[UIImagePickerControllerOriginalImage] as? UIImage!)!
              saveImage(image:backImageHolder!,key:Constants.ProofOfIdentity.backImageKey)
            showBackImage(image: backImageHolder!)
        }
        else if (imageMode==3)
        {
             selfieImageHolder=(info[UIImagePickerControllerOriginalImage] as? UIImage!)!
             saveImage(image:selfieImageHolder!,key:Constants.ProofOfIdentity.selfieImageKey)
            showSelfieImage(image: selfieImageHolder!)
        }
    }
    func saveDate(finished: () -> Void)
    {
         Helper.savePref(key: Constants.ProofOfIdentity.nationalityKey, value:CPP.selectedCountry.code)
        Helper.savePref(key: Constants.ProofOfIdentity.typeOfDocumentKey, value: documentLabel.text!)
         Helper.savePref(key: Constants.ProofOfIdentity.docNumberKey, value: documentNumberField.text!)
        Helper.savePref(key: Constants.ProofOfIdentity.expiryDateKey, value: dateLabel.text!)
        Helper.savePref(key: Constants.ProofOfIdentity.docNumberKey, value: documentNumberField.text!)
      finished()
        
    }
    func isReadyToSubmit()->Bool
    {
        if(documentNumberField.text?.isEmpty)!
        {
            return false
        }else if(!dateSet && dateIsMandatory)
        {
            return false
        }
        else if(shouldHideFrontImage)
        {
            return false
        }
        else if(shouldHideBackImage)
        {
            return false
        }
        else if(shouldHideSelfieImage)
        {
            return false
        }else{
            return true
        }
        
        
    }
    func saveImage(image:UIImage,key:String)
    {
        UserDefaults.standard.set(UIImagePNGRepresentation(image), forKey: key)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
}
