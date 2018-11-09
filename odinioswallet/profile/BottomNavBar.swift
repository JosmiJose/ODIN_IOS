//
//  BottomNavBar.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 10/07/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit

@IBDesignable
class BottomNavBar: UIView {
    
    class func createMyClassView() -> BottomNavBar {
        let myClassNib = UINib(nibName: "BottomNavigationBar", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! BottomNavBar
    }
}
