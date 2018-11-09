//
//  CreateWalletViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 25/06/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import Navajo_Swift
import Alamofire
import SwiftyJSON
class CreateWalletViewController: UIViewController,UITextFieldDelegate  {
    @IBAction func termsOfServiceClicked(_ sender: Any) {
         Helper.openGenericWebview(url:"api/tnc/",controller:self,title:NSLocalizedString("options_tos", comment: ""))
    }
    
    @IBOutlet weak var inputProgressView: UIProgressView!
    @IBOutlet weak var passwordInputFeedback: UILabel!
    @IBOutlet weak var createWalletButton: UIButton!
    @IBOutlet weak var emailTextField: BCTextField!
    @IBOutlet weak var passwordTextField: BCTextField!
    @IBOutlet weak var confirmPasswordTextField: BCTextField!
    var passwordStrength=0
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
        Helper.setUnderlined(textField: confirmPasswordTextField)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func passwordChanged(_ sender: Any) {
        if let input = sender as? BCTextField {
            
            if(input.tag==1)
            {
                let inputLength=input.text?.count
                if(inputLength!>0)
                {
                    inputProgressView.isHidden=false
                    passwordInputFeedback.isHidden=false;
                    passwordStrength=Helper.decidePasswordStrength(password:input.text!,passwordInputFeedback:passwordInputFeedback,inputProgressView:inputProgressView)
                }
                else
                {
                    inputProgressView.isHidden=true
                    passwordInputFeedback.isHidden=true;
                }
            }
            
            hideShowCreateWalletButton()
            
        }
        
    }
    func hideShowCreateWalletButton()
    {
        let passwordLength=passwordTextField.text?.count
        let confirmPasswordLength=confirmPasswordTextField.text?.count
        if(passwordLength!>0&&passwordLength==confirmPasswordLength)
        {
            showCreateWalletButton()
        }
        else{
            hideCreateWalletButton()
        }
    }
    func showCreateWalletButton()
    {
        createWalletButton.isHidden=false
    }
    func hideCreateWalletButton()
    {
        createWalletButton.isHidden=true
        
    }
    
    
    @IBAction func createWalletPressed(_ sender: Any) {
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
                // Get 1st TextField's text
              self.createWallet()
                
            })
            alert.addAction(acceptAction)
            alert.addAction(continueAction)
            self.present(alert, animated: true)
        }else{
             createWallet()
        }
        
        
    }
    func clearFields()
    {
        self.emailTextField.text=""
        self.passwordTextField.text=""
        self.confirmPasswordTextField.text=""
        DispatchQueue.main.async {
            self.inputProgressView.setProgress(0.1, animated: false)
        }
        self.inputProgressView.isHidden=true
        self.passwordInputFeedback.isHidden=true;
        self.emailTextField.becomeFirstResponder()
    }
    func createWallet(){
      
        Helper.showLoadingAlert(controller: self)
        let header = [
            "Content-Type" : "application/json; charset=utf-8"
        ]
        let body: [String: Any] = [
            "email": emailTextField.text,
            "password": passwordTextField.text
        ]
        
        let object = RestClient.postRequest(method:HTTPMethod.post,url: "api/users/register/",header:header, parameters: body,completion: { [weak self] data in
           
            if(data != nil || data.isEmpty)
            {
            let status = data["status"]
            if(status).boolValue
            {
            let alert = UIAlertController(title:NSLocalizedString("success_register_title", comment: "") , message:NSLocalizedString("success_register",comment: "") ,preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: NSLocalizedString("back_to_landing", comment: "") , style: .default, handler: { (action) -> Void in
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
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message: NSLocalizedString("registeration_error", comment: ""), controller: self)
        }
    }
   
    func hideKeyboard()
    {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
    func isReadyToSubmitForm()->Bool{
        let emailTxt = emailTextField.text!
         let passwordTxt = passwordTextField.text!
         let confirmPasswordTxt = confirmPasswordTextField.text!
        let isEqual = (passwordTxt == confirmPasswordTxt)
        if(!Helper.isValidEmail(email: emailTxt))
        {
            emailTextField.becomeFirstResponder()
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("invalid_email", comment: ""), controller: self)
            
            return false;
        }
        else if (passwordTxt.count<4)
        {
            passwordTextField.becomeFirstResponder()
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("invalid_password_too_short", comment: ""), controller: self)
            return false;
        }
        else if (passwordTxt.count>255)
        {
            passwordTextField.becomeFirstResponder()
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("invalid_password", comment: ""), controller: self)
            return false;
        }
        else if (!isEqual)
        {
            passwordTextField.becomeFirstResponder()
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("password_mismatch_error", comment: ""), controller: self)
            return false;
        }
        else{
        return true
        }
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
