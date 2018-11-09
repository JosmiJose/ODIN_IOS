//
//  Token.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 07/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit

class HistoryItem: NSObject {
    var id: Int?
    var isDbToken:Bool?
    var txHash:String?
    var token:String?
    var amount:Double?
    var toAddress:String?
    var odinEquivalent:Double?
     var txTimestamp:String?
     var fromAddress:String?
     var isPremium:Bool?
     var statusMsg:String?
    init(id: Int,isDbToken:Bool,txHash:String,token:String,amount:Double,toAddress:String,odinEquivalent:Double,txTimestamp:String,fromAddress:String,isPremium:Bool,statusMsg:String) {
        self.id = id
         self.isDbToken = isDbToken
         self.txHash = txHash
         self.token = token
         self.amount = amount
         self.toAddress = toAddress
         self.odinEquivalent = odinEquivalent
         self.txTimestamp=txTimestamp
         self.fromAddress=fromAddress
         self.isPremium=isPremium
         self.statusMsg=statusMsg
        
        
    }
    
}
