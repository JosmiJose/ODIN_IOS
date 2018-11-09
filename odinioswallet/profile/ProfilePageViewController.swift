//
//  ViewController.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 07/07/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIPageViewController,UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "personalInfo"),self.newVc(viewController: "resedential"),self.newVc(viewController: "investmentDetails"),self.newVc(viewController: "proof"),self.newVc(viewController: "review")]
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Update Profile"
    self.view.gestureRecognizers?.forEach({ (gesture) in
            view.removeGestureRecognizer(gesture)
        })
        self.dataSource = self
        self.delegate = self
        // Do any additional setup after loading the view.
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        ViewPagerLinker.pager=self
        if let scrollView = self.view.subviews.filter({$0.isKind(of: UIScrollView.self)}).first as? UIScrollView {
            scrollView.isScrollEnabled = false
        }
        
    }
    
    
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
       // self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    
    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            // return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            //return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
             return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    

}
