//
//  pointsHistoryRowCell.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 20/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit

class membershipHistoryRowCell: UITableViewCell {

    @IBOutlet weak var startDate: UILabel!
    
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var endDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
