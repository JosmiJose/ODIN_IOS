import Foundation
import XLPagerTabStrip
import SwiftyJSON
class PointsViewController: ButtonBarPagerTabStripViewController {
    
    @IBAction func backBtn(_ sender: Any) {
           dismiss(animated: true, completion: nil)
    }
    let blueInstagramColor = UIColor(red: 37/255.0, green: 111/255.0, blue: 206/255.0, alpha: 1.0)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
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
        super.viewDidLoad()
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard = UIStoryboard(name: "points", bundle: nil)
        let historyChild : pointsHistoryViewController = (storyboard.instantiateViewController(withIdentifier: "History")) as! pointsHistoryViewController
        
        
        let infoChild : pointsInfoViewController = (storyboard.instantiateViewController(withIdentifier: "Info")) as! pointsInfoViewController
        
        
        return [infoChild,historyChild]
    }
}
