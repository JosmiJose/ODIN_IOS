//
//  PinViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 29/06/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit

class PinViewController: UIViewController {
    var pressCount=0
    var mode:String = ""
    var pinTxt:String=""
      var confirmPinText:String=""
    var confirmMode:Bool=false
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var forthDot: UIImageView!
    @IBOutlet weak var firstDot: UIImageView!
    
    @IBOutlet weak var secondDot: UIImageView!
    
    @IBOutlet weak var thirdDot: UIImageView!
    var attempts=0
    override func viewDidLoad() {
        super.viewDidLoad()
        initTitle()
        // Do any additional setup after loading the view.
    }
    func initTitle()
    {
        if(mode=="CREATE")
        {
            titleText.text=NSLocalizedString("create_pin", comment: "")
        }
        else{
            titleText.text=NSLocalizedString("enter_pin", comment: "")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        if(sender.tag==10)
        {
            if(!confirmMode)
            {
                  pinTxt=String(pinTxt.dropLast())
            }else{
                  confirmPinText=String(confirmPinText.dropLast())
            }
          
            if(pressCount != 0)
            {
            if(pressCount == 1)
            {
                firstDot.image=UIImage(named:"PEPin-off")
            }
            if(pressCount == 2)
            {
                secondDot.image=UIImage(named:"PEPin-off")
            }
            if(pressCount == 3)
            {
                thirdDot.image=UIImage(named:"PEPin-off")
            }
            
            pressCount-=1
            }
            
        }else
        {
        if(!confirmMode)
        {
        pinTxt+=sender.tag.description
        }else{
          confirmPinText+=sender.tag.description
        }
        pressCount+=1
        if(pressCount == 1)
        {
            firstDot.image=UIImage(named:"PEPin-on")
        }
        if(pressCount == 2)
        {
            secondDot.image=UIImage(named:"PEPin-on")
        }
        if(pressCount == 3)
        {
            thirdDot.image=UIImage(named:"PEPin-on")
        }
        else if(pressCount==4)
        {
             forthDot.image=UIImage(named:"PEPin-on")
            // Delay 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.proceedPin()
            }
     
        }
        }
        
    }
    func proceedPin()
    {
        if(mode=="CREATE"||mode=="CHANGE")
        {
            if(!confirmMode)
            {
                reset(mode:true)
            }else
            {
                if(pinTxt==confirmPinText)
                {
                    Helper.savePref(key:Constants.pinValue.pinValueKey, value: pinTxt.sha256())
                    Helper.saveBoolPref(key:Constants.loggedIn.loggedInKey, value: true)
                    if(mode=="CREATE")
                    {
                        Helper.isLoggedOut=false
                        openNewStoryboard()
                    }
                    else if(mode=="CHANGE"){
                        TransPinMatchedManager.changed=true
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }
                else{
                    reset(mode: false)
                    Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("pin_mismatch", comment: ""), controller: self)
                }
            }
            
        }else{
            let currPin=Helper.readPref(key:Constants.pinValue.pinValueKey)
            if(currPin==pinTxt.sha256())
            {
                TransPinMatchedManager.matched=true
                self.dismiss(animated: true, completion: nil)
            }else{
                if(attempts==3)
                {
                    let alert = UIAlertController(title:NSLocalizedString("error_title", comment: "") , message:NSLocalizedString("pin_4_strikes", comment: "") ,preferredStyle: .alert)
                    let acceptAction = UIAlertAction(title: NSLocalizedString("back_to_main", comment: "") , style: .default, handler: { (action) -> Void in
                        Helper.clearUserDefaults()
                        Helper.isLoggedOut=true
                        Helper.backToLandingPage()
                    })
                    
                    alert.addAction(acceptAction)
                    
                    self.present(alert, animated: true)
                    
                    
                }else{
                    attempts+=1
                    reset(mode: false)
                    Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("enter_pin_mismatch", comment: ""), controller: self)
                }
                
            }
        }
    }
    func reset(mode:Bool)
    {
      firstDot.image=UIImage(named:"PEPin-off")
      secondDot.image=UIImage(named:"PEPin-off")
      thirdDot.image=UIImage(named:"PEPin-off")
      forthDot.image=UIImage(named:"PEPin-off")
        if(mode)
        {
           titleText.text=NSLocalizedString("confirm_pin", comment: "")
        }else{
             pinTxt=""
             confirmPinText=""
            initTitle()
        }
        
        pressCount=0
        confirmMode=mode
    }
    func openNewStoryboard() {
        let storyboard = UIStoryboard(name: "App", bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! AppMainViewController
        self.view.window?.rootViewController = controller
    }
    
}
