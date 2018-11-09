//
//  Connectivity.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 31/08/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import Foundation
import Alamofire
struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}
