//
//  teamDetailsViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 20/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var confirmPassword: BCTextField!
    var passwordStrength=0
    @IBOutlet weak var passwordInputFeedback: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBAction func updatePassword(_ sender: Any) {
        if (!isReadyToSubmitForm()) {
            clearFields()
            return;
        };
        
        hideKeyboard()
        if (passwordStrength<3){
            let alert = UIAlertController(title:NSLocalizedString("warning", comment: "") , message:NSLocalizedString("password_too_week",comment: "") ,preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: NSLocalizedString("yes", comment: "") , style: .default, handler: { (action) -> Void in
                // Get 1st TextField's text
                self.clearFields()
            })
            let continueAction = UIAlertAction(title: NSLocalizedString("polite_no", comment: "") , style: .default, handler: { (action) -> Void in
                self.updatePassword()
                
            })
            alert.addAction(acceptAction)
            alert.addAction(continueAction)
            self.present(alert, animated: true)
        }else{
          updatePassword()
        }
    }
    func clearFields()
    {
        self.confirmPassword.text=""
        self.currentPassword.text=""
        self.newPassword.text=""
        progressView.progress=0
        progressView.isHidden=true
        passwordInputFeedback.isHidden=true;
        self.currentPassword.becomeFirstResponder()
        
    }
    func updatePassword(){
        
        Helper.showLoadingAlert(controller: self)
          let token = NSLocalizedString("auth_prefix", comment: "")+" "+Helper.readPref(key:Constants.userToken.userTokenKey)
        let header = [
            "Content-Type" : "application/json; charset=utf-8",
            "Authorization" : token
        ]
        
        let body: [String: Any] = [
            "old_password": currentPassword.text,
            "new_password1": newPassword.text,
            "new_password2": confirmPassword.text
        ]
        
        let object = RestClient.postRequest(method:HTTPMethod.post,url: "api/users/password/change/",header:header, parameters: body,completion: { [weak self] data in
         
            if(data != nil)
            {
                let status = data["status"]
                if(status).boolValue
                {
                    let alert = UIAlertController(title:NSLocalizedString("password_changed", comment: "") , message:NSLocalizedString("password_changed_notice",comment: "") ,preferredStyle: .alert)
                    let acceptAction = UIAlertAction(title: NSLocalizedString("continue", comment: "") , style: .default, handler: { (action) -> Void in
                        // Get 1st TextField's text
                        self?.dismiss(animated: true, completion: {});
                        self?.navigationController?.popViewController(animated: true);
                    })
                    
                    alert.addAction(acceptAction)
                       self?.dismiss(animated: true)
                       {
                    self?.present(alert, animated: true)
                    }
                }
                else{
                    self?.dismiss(animated: true){
                          self?.showError(data: data)
                    }
                  
                }
                
            }
            else
            {
                 self?.dismiss(animated: true){
                self?.showError(data: data)
                }
            }
        })
        
    }
    func showError(data:JSON)
    {
        clearFields()
        let msgObj=data["result"]
        let msg=msgObj["message"]
        if(msg.stringValue != nil && !msg.stringValue.isEmpty)
        {
            if(msg=="{'old_password': ['Invalid password']}")
            {
                  Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("prev_password_incorrect", comment: ""), controller: self)
            }else{
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:msg.stringValue, controller: self)
            }
        }
        else{
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message: NSLocalizedString("change_password_error", comment: ""), controller: self)
        }
    }
    
    func hideKeyboard()
    {
        currentPassword.resignFirstResponder()
        newPassword.resignFirstResponder()
        confirmPassword.resignFirstResponder()
    }
    func isReadyToSubmitForm()->Bool{
        let currentTxt = currentPassword.text!
        let passwordTxt = newPassword.text!
        let confirmPasswordTxt = confirmPassword.text!
        let isEqual = (passwordTxt == confirmPasswordTxt)
        if(currentTxt.isEmpty)
        {
            currentPassword.becomeFirstResponder()
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("fill_fields", comment: ""), controller: self)
            
            return false;
        }
        else if (passwordTxt.count<4)
        {
            newPassword.becomeFirstResponder()
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("invalid_password_too_short", comment: ""), controller: self)
            return false;
        }
        else if (passwordTxt.count>255)
        {
            newPassword.becomeFirstResponder()
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("invalid_password", comment: ""), controller: self)
            return false;
        }
        else if (!isEqual)
        {
            newPassword.becomeFirstResponder()
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("password_mismatch_error", comment: ""), controller: self)
            return false;
        }
        else{
            return true
        }
    }
    @IBOutlet weak var currentPassword: BCTextField!
    
    @IBAction func textChanged(_ sender: Any) {
        if let input = sender as? BCTextField {
            
            if(input.tag==1)
            {
                let inputLength=input.text?.count
                if(inputLength!>0)
                {
                    progressView.isHidden=false
                    passwordInputFeedback.isHidden=false;
                    passwordStrength=Helper.decidePasswordStrength(password:newPassword.text!,passwordInputFeedback:passwordInputFeedback,inputProgressView:progressView)
                }
                else
                {
                    progressView.isHidden=true
                    passwordInputFeedback.isHidden=true;
                }
            }
            
            
        }
    }
    @IBOutlet weak var newPassword: BCTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //setInputUnderlined()
        currentPassword.becomeFirstResponder()
      
    }
    func setInputUnderlined()
    {
        Helper.setUnderlined(textField: confirmPassword)
        Helper.setUnderlined(textField: currentPassword)
        Helper.setUnderlined(textField: newPassword)
    }
    static func instantiate() -> ChangePasswordViewController? {
        return UIStoryboard(name: "settings", bundle: nil).instantiateViewController(withIdentifier: "changePassword") as? ChangePasswordViewController
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
   

}
