//
//  Token.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 07/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit

class membershipHistory: NSObject {
    var userId: Int?
    var pointDate:String?
    var pointsAdded: Int?
    var pointsHistoryId: Int?
    
    
    init(userId: Int,pointDate:String,pointsAdded: Int,pointsHistoryId: Int) {
         self.userId = userId
          self.pointDate = pointDate
          self.pointsAdded = pointsAdded
          self.pointsHistoryId = pointsHistoryId
        
    }
    
}
