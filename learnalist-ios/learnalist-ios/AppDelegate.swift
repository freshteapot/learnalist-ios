//
//  AppDelegate.swift
//  learnalist-ios
//
//  Created by Chris Williams on 19/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let bottomView = BottomToolBarController()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let prefs = Bundle.main.path(forResource: "Settings", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: prefs!)
        let userDefaults = UserDefaults.standard
        
        //userDefaults.set(dict, forKey: "defaults")                // without this code doesn't work
        userDefaults.register(defaults: dict as! [String : Any])
        
        
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.black
        
        // Check which window to show
        var model = Model()
        let settings:SettingsInfo = model.getSettings()

        let vc = settings.username.isEmpty ? UIApplication.getSettings() : UIApplication.getSplash()
        
        let navigationVC = UINavigationController(rootViewController: vc)
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
        
        
        window?.addSubview(bottomView)

        bottomView.snp.makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo((window?.snp.height)!).multipliedBy(0.1)
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




extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    
    class func getSettings() -> UIViewController {
        let model = Model()
        let settings:SettingsInfo = model.getSettings()
        let vc = SettingsViewController(info:settings)
        return vc;
    }
    
    class func getSplash() -> UIViewController {
        let vc = SplashViewController()
        return vc;
    }
    
    class func getNewList() -> UIViewController {
        let vc = AlistNewViewController()
        return vc;
    }
    
    class func getLastList() -> UIViewController {
        let vc = LastListViewController()
        return vc;
    }
}

