//
//  SettingsViewController.swift
//  learnalist-ios
//
//  Created by Chris Williams on 29/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import Foundation
import UIKit
import Signals

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = []
        let nc = self.navigationController as? SettingsNavigationController

        let swipeDown = UISwipeGestureRecognizer(target: nc, action: #selector (SettingsNavigationController.toList))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(swipeDown)


        view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nc, action: #selector(SettingsNavigationController.toList))


        let settingsView = SettingsView(frame: CGRect.zero)
        view.addSubview(settingsView)

        settingsView.snp.makeConstraints{(make) -> Void in
            make.top.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(view.snp.height).multipliedBy(0.8)
        }

        settingsView.onTap.subscribe(on: self) { (settings) in
            nc?.toList()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
