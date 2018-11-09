//
//  Token.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 07/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit

class packageItem: NSObject {
    var managerId: Int?
    var updatedAt:String?
    var noOfDays: Int?
    var subscribe_id: Int?
    var subscribtionDetails:String?
    var deletedAt:String?
    var points: Int?
    
    init(managerId: Int,updatedAt:String,noOfDays: Int,subscribe_id: Int,subscribtionDetails:String,deletedAt:String,points: Int) {
          self.managerId = managerId
          self.updatedAt = updatedAt
          self.noOfDays = noOfDays
          self.subscribe_id = subscribe_id
        self.subscribtionDetails = subscribtionDetails
        self.deletedAt = deletedAt
        self.points = points
        
    }
    
}
