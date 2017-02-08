//
//  AppDelegate.swift
//  learnalist-ios
//
//  Created by Chris Williams on 29/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var sync: LearnalistSync!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        sync = LearnalistSync()
        sync.startTimer()

        // Override point for customization after application launch.
            // Override point for customization after application launch.
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.backgroundColor = UIColor.black
        firstRun()

        let model = LearnalistModel()

        let vc = MainViewController(model:model)
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("Do I need this one 1")
        sync.stopTimer()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        sync.startTimer()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func firstRun() {

        let prefs = Bundle.main.path(forResource: "Settings", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: prefs!)
        let userDefaults = UserDefaults.standard

        //userDefaults.set(dict, forKey: "defaults")                // without this code doesn't work
        userDefaults.register(defaults: dict as! [String : Any])
    }
}

extension UIApplication {
    class func getModel() -> LearnalistModel {
        let window = UIApplication.shared.keyWindow!
        let vc = window.rootViewController as! MainViewController
        return vc.getModel()
    }
}
