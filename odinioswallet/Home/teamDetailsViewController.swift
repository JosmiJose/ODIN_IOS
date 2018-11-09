//
//  teamDetailsViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 20/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit

class teamDetailsViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    @IBAction func linkedInClicked(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: (member?.linkedInProfile)!)! as URL)
    }
    
    @IBOutlet weak var linkedInProfile: UIButton!
    @IBOutlet weak var position: UILabel!
    var member:teamMember?
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.setImage(imageView: profileImage, imageString: (member?.picture)!,placeholder: "place_holder")
        profileName.text=member?.employeeName
        linkedInProfile.titleLabel?.text=member?.linkedInProfile
        position.text=member?.about
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    static func instantiate() -> teamDetailsViewController? {
        return UIStoryboard(name: "Children", bundle: nil).instantiateViewController(withIdentifier: "teamDetails") as? teamDetailsViewController
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
