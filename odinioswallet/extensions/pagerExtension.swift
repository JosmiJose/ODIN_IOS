//
//  pagerExtension.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 07/07/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import Foundation
import UIKit
extension UIPageViewController {
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        if let currentViewController = viewControllers?[0] {
            if let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) {
                setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
            }
        }
    }
    func goToPreviousePage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        if let currentViewController = viewControllers?[0] {
            if let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) {
                setViewControllers([prevPage], direction: .reverse, animated: animated, completion: completion)
            }
        }
    }
}
