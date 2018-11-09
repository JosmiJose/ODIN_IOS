

import Foundation
import XLPagerTabStrip

class ExchangeViewController: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var containerLayout: UIView!
    
    @IBOutlet weak var emptyMsg: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let  kycStatus=Helper.readPref(key:Constants.kycStatus.kycStatusKey)
        if(!(kycStatus==Constants.kycStatusTypes.approved))
        {
             self.showEmptyMsgLayout(msg: NSLocalizedString("need_verify", comment: ""))
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var type = ""
    var itemInfo = IndicatorInfo(title:NSLocalizedString("exchange", comment: ""))
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    func showEmptyMsgLayout(msg:String)
    {
        self.containerLayout.isHidden=true
        self.emptyMsg.isHidden=false
        self.emptyMsg.text=msg
    }
    func showContainerLayout()
    {
        self.containerLayout.isHidden=false
        self.emptyMsg.isHidden=true
    }
}
