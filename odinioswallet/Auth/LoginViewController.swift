//
//  LoginViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 25/06/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import EzPopup
class LoginViewController: UIViewController,UITextFieldDelegate {
    @IBAction func forgotPassword(_ sender: Any) {
        forgetPassword()
    }
    func forgetPassword()
    {
        let forgetPasswordVC = ForgotPasswordViewController.instantiate()
        let popupVC = PopupViewController(contentController: forgetPasswordVC!, popupWidth: 250 , popupHeight: 150)
        popupVC.cornerRadius = 5
        forgetPasswordVC?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(popupVC, animated: true, completion: nil)
    }
    @IBOutlet weak var emailTextField: BCTextField!
    
    @IBOutlet weak var passwordTextField: BCTextField!
    @IBAction func loginContinue(_ sender: Any) {
        if (!isReadyToSubmitForm()) {
            clearFields()
            return;
        };
        
          hideKeyboard()

          login()
    }
    func login(){
        
        Helper.showLoadingAlert(controller: self)
        let header = [
            "Content-Type" : "application/json; charset=utf-8"
        ]
        let body: [String: Any] = [
            "email": emailTextField.text,
            "password": passwordTextField.text
        ]
        
        let object = RestClient.postRequest(method:HTTPMethod.post,url: "api/users/login/",header: header,parameters: body,completion: { [weak self] data in
        
            if(data != nil)
            {
                let status = data["status"]
                var dismissed:Bool=false
                if(data["is_email_verified"].exists())
                {
                      let isEmailVerified=data["is_email_verified"]
                    if(!isEmailVerified.boolValue)
                    {
                        dismissed=true
                        self?.dismiss(animated: true) {
                            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("email_not_verified_msg", comment: ""), controller: self!)
                        }
                    }
                    
                }
                
                    if(status).boolValue
                    {
                        let key=data["result"]["key"].stringValue
                        let kycStatus=data["kyc_status"].stringValue
                        Helper.savePref(key:Constants.userToken.userTokenKey, value: key)
                        Helper.savePref(key:Constants.kycStatus.kycStatusKey, value: kycStatus)
                        self?.dismiss(animated: true) {
                            Helper.startPinAuth(mode: "CREATE",delegate: self!)
                        }
                        
                        
                    }
                    else{
                        if(dismissed)
                        {
                               self?.showError(data: data)
                        }
                        else{
                        self?.dismiss(animated: true) {
                           self?.showError(data: data)
                        }
                        }
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
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message: NSLocalizedString("login_error", comment: ""), controller: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setInputUnderlined()
        emailTextField.becomeFirstResponder()
       
        

        // Do any additional setup after loading the view.
    }
    func setInputUnderlined()
    {
        Helper.setUnderlined(textField: emailTextField)
        Helper.setUnderlined(textField: passwordTextField)
    }
    func isReadyToSubmitForm()->Bool{
        let emailTxt = emailTextField.text!
        let passwordTxt = passwordTextField.text!
    
        if(!Helper.isValidEmail(email: emailTxt))
        {
            emailTextField.becomeFirstResponder()
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("invalid_email", comment: ""), controller: self)
            
            return false;
        }
        else if (passwordTxt.isEmpty)
        {
            passwordTextField.becomeFirstResponder()
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("invalid_password", comment: ""), controller: self)
            return false;
        }
        
        return true
    }
    func hideKeyboard()
    {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    func clearFields()
    {
        self.emailTextField.text=""
        self.passwordTextField.text=""
        self.emailTextField.becomeFirstResponder()
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
