//
//  Token.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 07/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit

class Company: NSObject {
    var totalSupply: Double?
    var companyId: Int?
    var permiumSupply: Double?
    var dateOfTokenRelease:String?
    var industryType:String?
    var noOfDecimals: Int?
    var icoStatus:String?
    var whitePaper:String?
    var companyName:String?
    var remainSupply: Double?
    var companyLogo:String?
    var walletId:String?
     var contractSourceCode:String?
    var odinEquivalent:Double?
     var companyReview:String?
     var companyUserId: Int?
      var updatedAt: String?
     var preIcoName: String?
       var website: String?
     var establishedDate: String?
     var companyOverview: String?
    var contractAbi: String?
     var contractAddress: String?
     var companyRating: Int?
       var icoStartDate: String?
     var remainPremiumSupply: Double?
     var createdAt: String?
     var preIcoTicker: String?
     var icoEndDate:String?
    var odinHoldings:Double?
    var deletedAt:String?
    var teamMembers:[teamMember]
    
    
    init(totalSupply: Double,companyId: Int,permiumSupply: Double,dateOfTokenRelease:String,industryType:String,noOfDecimals: Int,icoStatus:String,whitePaper:String,companyName:String,remainSupply: Double,companyLogo:String,walletId:String,contractSourceCode:String,odinEquivalent:Double,companyReview:String,companyUserId:Int,updatedAt:String,preIcoName:String,website:String,establishedDate:String,companyOverview:String,contractAbi:String,contractAddress:String,companyRating:Int,icoStartDate:String,remainPremiumSupply:Double,createdAt:String,preIcoTicker:String,icoEndDate:String,odinHoldings:Double,deletedAt:String,members:[teamMember]) {
        self.totalSupply=totalSupply
        self.companyId=companyId
        self.permiumSupply=permiumSupply
        self.dateOfTokenRelease=dateOfTokenRelease
        self.industryType=industryType
        self.noOfDecimals=noOfDecimals
        self.icoStatus=icoStatus
       self.whitePaper=whitePaper
        self.companyName=companyName
        self.remainSupply=remainSupply
        self.companyLogo=companyLogo
        self.walletId=walletId
        self.contractSourceCode=contractSourceCode
        self.odinEquivalent=odinEquivalent
        self.companyReview=companyReview
        self.companyUserId=companyUserId
        self.updatedAt=updatedAt
        self.preIcoName=preIcoName
       self.website=website
        self.establishedDate=establishedDate
        self.companyOverview=companyOverview
        self.contractAbi=contractAbi
        self.contractAddress=contractAddress
       self.companyRating=companyRating
       self.icoStartDate=icoStartDate
        self.remainPremiumSupply=remainPremiumSupply
       self.createdAt=createdAt
        self.preIcoTicker=preIcoTicker
       self.icoEndDate=icoEndDate
        self.odinHoldings=odinHoldings
        self.deletedAt=deletedAt
        self.teamMembers=members
        
    }
    
}
