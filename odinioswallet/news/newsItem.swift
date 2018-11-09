//
//  Token.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 07/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit

class newsItem: NSObject {
    var updatedAt:String?
    var body:String?
     var uploadImage:String?
    var newFlag:String?
    var createdAt:String?
    var title:String?
    var desc:String?
    var subscriptionId: Int?
    var newsId: Int?
    
    
    init(updatedAt:String,body:String,uploadImage:String,newFlag:String,createdAt:String,title:String,desc:String,subscriptionId:Int,newsId:Int) {
        self.updatedAt = updatedAt
        self.body = body
        self.uploadImage = uploadImage
        self.newFlag = newFlag
        self.createdAt = createdAt
        self.title = title
        self.desc = desc
        self.subscriptionId = subscriptionId
        self.newsId = newsId
    }
    
}
