//
//  PersonalInfoController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 06/07/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import CountryPickerView
class ProofOfIdentityController: UIViewController ,UINavigationBarDelegate{
    var myTableViewController :ProofFormTableView?
    @IBAction func prevButtonClicked(_ sender: Any) {
        ViewPagerLinker.pager?.goToPreviousePage()
    }
    @IBAction func nextButtonClicked(_ sender: Any) {
        if(myTableViewController?.isReadyToSubmit())!
        {
            saveData()
          
        }else{
            Helper.showErrorAlert(title: NSLocalizedString("error_title", comment: ""), message:NSLocalizedString("fill_fields", comment: ""), controller: self)
        }
    }
    func saveData ()
    {
            self.myTableViewController?.saveDate()
                {
                   ViewPagerLinker.pager?.goToNextPage()
        }
    }
    @IBOutlet weak var navBar: UINavigationBar!
    
    var pageViewController: UIPageViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        myTableViewController = self.childViewControllers[0] as! ProofFormTableView
        let theTableView = myTableViewController?.tableView
        theTableView?.separatorStyle = UITableViewCellSeparatorStyle.none
       
      
        
    }
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBar.tintColor=UIColor.white
        navBar.barTintColor=UIColor.Blue.PrimaryBlue
        navBar.barStyle = .blackOpaque
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
