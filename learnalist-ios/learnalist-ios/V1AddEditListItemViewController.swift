//
//  V1AddEditListItemViewController.swift
//  learnalist-ios
//
//  Created by Chris Williams on 31/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import UIKit
import Signals


class V1AddEditListItemViewController: UIViewController {
    let onSave = Signal<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        let addEditNavigationController = self.navigationController as? AddEditNavigationController

        view.backgroundColor = UIColor.white

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "List", style: .plain, target: addEditNavigationController, action: #selector (AddEditNavigationController.toList))

        let editView = V1EditListViewItem(frame: CGRect.zero)
        view.addSubview(editView)

        editView.snp.makeConstraints{(make) -> Void in
            make.top.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }


        editView.onTap.subscribe(on: self, callback: self.onEditSave)
    }

    func onEditSave(data: String) {
        self.onSave.fire(data)
    }
}
