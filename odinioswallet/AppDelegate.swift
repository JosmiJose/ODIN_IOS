//
//  AppDelegate.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 22/06/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SideMenu
import Firebase
import Fabric
import Crashlytics
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
      
        let navigationBarAppearace = UINavigationBar.appearance()
        
        // Color of Navigation Bar background
        navigationBarAppearace.barTintColor = UIColor.Blue.PrimaryBlue
        // Color of Navigation Bar Title
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationBarAppearace.titleTextAttributes = textAttributes
        // Color of Navigation Bar back indicator, button titles, button images
        navigationBarAppearace.tintColor = UIColor.white
        
        navigationBarAppearace.barStyle = .blackOpaque
        
    
        
        if let statusbar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusbar.backgroundColor = UIColor.Blue.PrimaryBlue
        }
        IQKeyboardManager.shared.enable = true
        var initialViewController:UIViewController
        var storyboard:UIStoryboard
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let isLoggedIn=Helper.readBoolPref(key: Constants.loggedIn.loggedInKey)
        
        if(!isLoggedIn)
        {
             storyboard = UIStoryboard(name: "Main", bundle: nil)
            
             initialViewController = storyboard.instantiateViewController(withIdentifier: "mainInitial")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        else{
         let storyboard = UIStoryboard(name: "App", bundle: nil)
            
          initialViewController = storyboard.instantiateViewController(withIdentifier: "appInitial")
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        }
        

        return true
    }
   
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

   
}

