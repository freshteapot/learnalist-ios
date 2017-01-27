//
//  AlistNewViewController.swift
//  learnalist-ios
//
//  Created by Chris Williams on 27/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import Foundation
import UIKit

class AlistNewViewController: UIViewController, BottomToolBarControllerDelegate {
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.red
        self.navigationItem.title = "1st step in adding a list"
    }
    
    func onAdd() {
        print("onAdd: do nothing")
    }
    
    func onSplash() {
        print("onSplash: change to splash")
        let vc = UIApplication.getSplash()
        self.navigationController?.setViewControllers([vc], animated: false)
    }
    
    func onLastList() {
        print("onLastList")
        let vc = UIApplication.getLastList()
        self.navigationController?.setViewControllers([vc], animated: false)
    }
}
