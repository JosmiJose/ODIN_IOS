//
//  Token.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 07/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit

class memberHistory: NSObject {
    var subscriptionId: Int?
    var subscriptionDate:String?
    var userId: Int?
     var subscriptionEndDate:String?
     var usersubscriptionId:Int?
      var pointsUsed: Int?
   
    
    
    init(subscriptionId: Int,subscriptionDate:String,userId: Int,subscriptionEndDate:String,usersubscriptionId: Int,pointsUsed: Int) {
         self.subscriptionId = subscriptionId
          self.subscriptionDate = subscriptionDate
          self.userId = userId
          self.subscriptionEndDate = subscriptionEndDate
        self.usersubscriptionId = usersubscriptionId
        self.pointsUsed = pointsUsed
        
    }
    
}
