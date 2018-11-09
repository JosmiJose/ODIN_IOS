//
//  RequestTableViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 14/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import CoreImage
import SwiftyJSON
import Toaster


class RequestTableViewController: UITableViewController {

    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var tapText: UILabel!
  
    @IBOutlet weak var addressText: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        let kycObject:JSON = Helper.getProfileObject()
        let kycStatus=Helper.readPref(key:Constants.kycStatus.kycStatusKey)
        let tap = UITapGestureRecognizer(target: self, action: #selector(RequestTableViewController.tapFunction))
        addressText.isUserInteractionEnabled = true
        addressText.addGestureRecognizer(tap)
        if(kycObject != nil && kycStatus == Constants.kycStatusTypes.approved)
        {
         addressText.text=kycObject["wallet_id"].stringValue
        if(restorationIdentifier=="requestEther")
        {
            if let img = generateQRCode(from: kycObject["wallet_id"].stringValue) {
                qrImage.image=img
            }
        }else if(restorationIdentifier=="requestOdin"){
            let json = JSON.init(["to":kycObject["wallet_id"].stringValue, "mode": "erc20__transfer","contract_address":"0x7cB57B5A97eAbe94205C07890BE4c1aD31E486A8"])
            let string1:String = json.rawString()!
            if let img = generateQRCode(from: string1) {
                qrImage.image=img
            }
        }
        }
        else{
            addressText.text=NSLocalizedString("account_must_be_verified_qr", comment: "")
            tapText.isHidden=true
        }
        

    }
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        UIPasteboard.general.string = addressText.text
        Toast(text: NSLocalizedString("copied_to_clipboard", comment: "")).show()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
   
    func createQRFromString(_ str: String) -> CIImage? {
        let stringData = str.data(using: String.Encoding.utf8)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(stringData, forKey: "inputMessage")
        
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        return filter?.outputImage
    }
    
   
    
}
