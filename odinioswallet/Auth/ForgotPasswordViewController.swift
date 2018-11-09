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
class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var email: BCTextField!
    
    @IBAction func updatePassword(_ sender: Any) {
        if (!isReadyToSubmitForm()) {
            clearFields()
            return;
        };
        
        hideKeyboard()

        forgetPassword()
    }
    func clearFields()
    {
        self.email.text=""
       
        self.email.becomeFirstResponder()
    }
    func forgetPassword(){
        
        Helper.showLoadingAlert(controller: self)
         
        let header = [
            "Content-Type" : "application/json; charset=utf-8"
        ]
        
        let body: [String: Any] = [
            "email": email.text,
        ]
        
        let object = RestClient.postRequest(method:HTTPMethod.post,url: "api/users/password/reset/",header:header, parameters: body,completion: { [weak self] data in

            if(data != nil)
            {
                let status = data["status"]
                if(status).boolValue
                {
                    let alert = UIAlertController(title:NSLocalizedString("email_sent", comment: "") , message:NSLocalizedString("email_sent_msg",comment: "") ,preferredStyle: .alert)
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
            
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:msg.stringValue, controller: self)

        }
        else{
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message: NSLocalizedString("change_password_error", comment: ""), controller: self)
        }
    }
    
    func hideKeyboard()
    {
        email.resignFirstResponder()

    }
    func isReadyToSubmitForm()->Bool{
        let emailTxt = email.text!
       
        if(!Helper.isValidEmail(email: emailTxt))
        {
            email.becomeFirstResponder()
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("invalid_email", comment: ""), controller: self)
            
            return false;
        }
        else{
            return true
        }
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  setInputUnderlined()
        email.becomeFirstResponder()
      
    }
    func setInputUnderlined()
    {
        Helper.setUnderlined(textField: email)

    }
    static func instantiate() -> ForgotPasswordViewController? {
        return UIStoryboard(name: "settings", bundle: nil).instantiateViewController(withIdentifier: "forgotPassword") as? ForgotPasswordViewController
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
}
