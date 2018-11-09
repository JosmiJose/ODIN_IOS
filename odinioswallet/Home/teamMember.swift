//
//  teamMember.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 17/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import Foundation
class teamMember: NSObject {
      var picture:String?
     var companyId:Int?
      var employeeName:String?
     var id:Int?
      var about:String?
      var linkedInProfile:String?
      var nationality:String?
    init(picture:String,companyId:Int,employeeName:String,id:Int,about:String,linkedInProfile:String,nationality:String)
     {
        self.picture=picture
        self.companyId=companyId
        self.employeeName=employeeName
        self.id=id
        self.about=about
        self.linkedInProfile=linkedInProfile
        self.nationality=nationality
    }
}
