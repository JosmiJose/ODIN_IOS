//
//  File.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 09/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import Foundation
extension UIView {
    func addDashedLine(strokeColor: UIColor, lineWidth: CGFloat) {
        
        let dottedPattern = UIImage(named: "dashed_image")
         self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(patternImage: dottedPattern!).cgColor
    }
}
