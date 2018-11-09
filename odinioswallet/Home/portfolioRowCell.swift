//
//  reviewItemCell.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 20/07/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit

class portfolioRowCell: UITableViewCell {

    @IBOutlet weak var tokenOdinValue: UILabel!
    @IBOutlet weak var tokenHoldings: UILabel!

    @IBOutlet weak var tokenName: UILabel!
    
    @IBOutlet weak var tokenIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
