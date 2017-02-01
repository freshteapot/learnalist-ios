//
//  TabLastListViewController.swift
//  learnalist-ios
//
//  Created by Chris Williams on 29/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import Foundation
import UIKit

class TabLastListViewController: UINavigationController, UINavigationControllerDelegate {

    let titleToUse = "Last List"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []

        self.view.backgroundColor = UIColor.black
        self.title = titleToUse

        let vc = LastListViewController()
        self.setViewControllers([vc], animated: false)
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
