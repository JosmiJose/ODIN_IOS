//
//  reviewItemCell.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 20/07/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit

class reviewItemCell: UITableViewCell {

    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
