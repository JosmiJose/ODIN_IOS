//
//  Token.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 07/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit

class Token: NSObject {
    var decimals: Int?
    var isDbToken:Bool?
    var tokenName:String?
    var tokenImage:String?
    var holdings:Double?
    var tokenLongName:String?
    var odinEquivalent:Double?
    
    init(decimals: Int,isDbToken:Bool,tokenName:String,tokenImage:String,holdings:Double,tokenLongName:String,odinEquivalent:Double) {
        self.decimals = decimals
         self.isDbToken = isDbToken
         self.tokenName = tokenName
         self.tokenImage = tokenImage
         self.holdings = holdings
         self.tokenLongName = tokenLongName
         self.odinEquivalent = odinEquivalent
        
    }
    
}
