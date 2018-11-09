//
//  teamCollectionViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 17/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import EzPopup

private let reuseIdentifier = "Cell"

class teamCollectionViewController: UICollectionViewController {
    var company:Company?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to pvarerve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if (company?.teamMembers.count)! > 0 {
            self.collectionView?.restore()
            return 1
        } else {
            self.collectionView?.setEmptyMessage(NSLocalizedString("no_team_members", comment: ""))
            
            return 0
        }
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (company?.teamMembers.count)!
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath)as! profileCell
        Helper.setImage(imageView: cell.profileImage, imageString: (company?.teamMembers[indexPath.row].picture)!,placeholder: "place_holder")
        cell.profileName.text=company?.teamMembers[indexPath.row].employeeName
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width / 2
        cell.profileImage.clipsToBounds = true
      
        // Configure the cell
    
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let teamDetailsVC = teamDetailsViewController.instantiate()
        teamDetailsVC?.member=company?.teamMembers[indexPath.row]
        let popupVC = PopupViewController(contentController: teamDetailsVC!, popupWidth: 250 , popupHeight: 250)
        popupVC.cornerRadius = 5
        teamDetailsVC?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(popupVC, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

}
