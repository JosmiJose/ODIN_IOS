//
//  reviewItemCell.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 20/07/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
protocol OptionButtonsDelegate{
    func txHashTapped(at index:IndexPath)
}
class historyRowCell: UITableViewCell {
   
    var delegate:OptionButtonsDelegate!
    @IBOutlet weak var txHash: UIButton!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var token: UILabel!
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var amount: UILabel!
    var indexPath:IndexPath!
    @IBAction func txHashClicked(_ sender: UIButton) {
        self.delegate?.txHashTapped(at: indexPath)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
