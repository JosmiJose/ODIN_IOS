import Foundation
import XLPagerTabStrip
import SwiftyJSON
import SideMenu
class RequestViewController: ButtonBarPagerTabStripViewController {
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
    @IBAction func buttonBalanceChanged(_ sender: Any) {
        if(Helper.balanceMode==1)
        {
            Helper.balanceMode=2
            initBalance()
        }else{
            Helper.balanceMode=1
            initBalance()
        }
    }
    @IBOutlet weak var balanceButton: UIButton!
    @IBOutlet weak var shadowView: UIView!
    let blueInstagramColor = UIColor(red: 37/255.0, green: 111/255.0, blue: 206/255.0, alpha: 1.0)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initBalance()
    }
    override func viewDidLoad() {
        // change selected bar color
       
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = UIColor.Green.PrimaryGreen
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0

        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = UIColor.Green.PrimaryGreen
        }
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        super.viewDidLoad()
    }

    // MARK: - PagerTabStripDataSource
    func initBalance()
    {
        let profile=Helper.getProfileObject()
        if(profile != nil)
        {
            setBalance(profile: profile)
        }
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
            let storyboard = UIStoryboard(name: "Children", bundle: nil)
        let odinChild : RequestOdinViewController = (storyboard.instantiateViewController(withIdentifier: "RequestOdin")) as! RequestOdinViewController
      
    
        let ethChild : RequestEtherViewController = (storyboard.instantiateViewController(withIdentifier: "RequestEther")) as! RequestEtherViewController
    
       
        return [odinChild,ethChild]
    }
    @IBAction func showSlideMenu(_ sender: Any) {
          ViewPagerLinker.sideMenuBaseController=self
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        
    }
    func setBalance(profile:JSON)
    {
    Helper.setGenericBalance(profile:profile,balanceButton:balanceButton)
    }
    // MARK: - Custom Action
    @IBAction func scanQrCode(_ sender: Any) {
        let parent = self.parent as! UIViewController
        let superParent=parent.parent as! AppMainViewController
        Helper.captureQrCode(controller: superParent)
    }
}
