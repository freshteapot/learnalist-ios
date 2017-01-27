//
//  SplashViewController.swift
//  learnalist-ios
//
//  Created by Chris Williams on 26/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import Foundation
import UIKit

class SplashViewController: UIViewController, BottomToolBarControllerDelegate {

    override func viewDidLoad() {
        view.backgroundColor = UIColor.yellow
        self.navigationItem.title = "Splash: my lists"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "settings", style: .plain, target: self, action: #selector(SplashViewController.settingsButtonTapped))
    }
    
    func settingsButtonTapped() {
        let vc = UIApplication.getSettings()
        self.navigationController?.setViewControllers([vc], animated: false)
    }
    
    func onAdd() {
        print("onAdd")
        let vc = UIApplication.getNewList()
        self.navigationController?.setViewControllers([vc], animated: false)
    }
    
    func onSplash() {
        print("onSplash: do nothing")
    }
    
    func onLastList() {
        print("onLastList")
        let vc = UIApplication.getLastList()
        self.navigationController?.setViewControllers([vc], animated: false)
    }
}
