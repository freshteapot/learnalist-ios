//
//  V1EditListViewController.swift
//  learnalist-ios
//
//  Created by Chris Williams on 31/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import UIKit

class V2EditListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        let addEditNavigationController = self.navigationController as? AddEditNavigationController

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: addEditNavigationController, action: #selector (AddEditNavigationController.cancelList))

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: addEditNavigationController, action: #selector (AddEditNavigationController.toAdd))

        view.backgroundColor = UIColor.white

        let editView = V2EditListView(frame: CGRect.zero)
        view.addSubview(editView)

        editView.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(view.snp.height).multipliedBy(0.8)
            make.top.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }
    }
}
