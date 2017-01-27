//
//  LastListViewController.swift
//  learnalist-ios
//
//  Created by Chris Williams on 27/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import Foundation
import UIKit

class LastListViewController: UIViewController, BottomToolBarControllerDelegate {
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.blue
        self.navigationItem.title = "Show the last x lists I have viewed."
    }
    
    func onAdd() {
        print("onAdd: change to newList")
        let vc = UIApplication.getNewList()
        self.navigationController?.setViewControllers([vc], animated: false)
    }
    
    func onSplash() {
        print("onSplash: change to splash")
        let vc = UIApplication.getSplash()
        self.navigationController?.setViewControllers([vc], animated: false)
    }
    
    func onLastList() {
        print("onLastList: do nothing")
    }
}
