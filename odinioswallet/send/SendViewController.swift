//
//  SendViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 02/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import SwiftyJSON
import SideMenu
class SendViewController: UIViewController {
   func stopSync()
   {
    let buttonItemView = syncIcon.value(forKey: "view") as? UIView
    buttonItemView?.stopRotating()
    }
    @IBOutlet weak var syncIcon: UIBarButtonItem!
    @IBAction func syncData(_ sender: Any) {
        let buttonItemView = syncIcon.value(forKey: "view") as? UIView
        buttonItemView?.startRotating()
       let parent = self.parent as! UIViewController
       let superParent=parent.parent as! AppMainViewController
        superParent.getProfileNetworkCall(fromSync: true,syncSource: 0)
    }
    @IBAction func scanQrCode(_ sender: Any) {
        let parent = self.parent as! UIViewController
        let superParent=parent.parent as! AppMainViewController
        Helper.captureQrCode(controller: superParent)
    }
    var myTableViewController :sendTableViewController?
    @IBOutlet weak var emptyMsg: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var balanceButton: UIButton!
   
    @IBAction func changeBalanceMode(_ sender: Any) {
        if(Helper.balanceMode==1)
        {
            Helper.balanceMode=2
            initBalance()
        }else{
            Helper.balanceMode=1
            initBalance()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         myTableViewController = self.childViewControllers[0] as! sendTableViewController
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         initBalance()
       
    }
   
    func showContainerLayout()
    {
        self.container.isHidden=false
        self.emptyMsg.isHidden=true
    }
    func showEmptyMsgLayout(msg:String)
    {
        self.container.isHidden=true
        self.emptyMsg.isHidden=false
        self.emptyMsg.text=msg
    }
    func initBalance()
    {
        let profile=Helper.getProfileObject()
        if(profile != nil)
        {
            setBalance(profile: profile)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showSlideMenu(_ sender: Any) {
        ViewPagerLinker.sideMenuBaseController=self
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        
    }
    func setQRCodeResult(result:String)
    {
        myTableViewController?.setQRCodeResult(result: result)
    }
    func setBalance(profile:JSON)
    {
        Helper.setGenericBalance(profile:profile,balanceButton:balanceButton)
    }
    func appendTokens(tokens:[Token])
    {
        myTableViewController?.appendTokens(tokens: tokens)
    }
    func initData()
    {
        myTableViewController?.initData()
    }

}
