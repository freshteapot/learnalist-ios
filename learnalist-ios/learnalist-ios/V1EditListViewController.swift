//
//  V1EditListViewController.swift
//  learnalist-ios
//
//  Created by Chris Williams on 31/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import UIKit

class V1EditListViewController: UIViewController {
    var listView:V1EditListView!
    var items = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        let addEditNavigationController = self.navigationController as? AddEditNavigationController

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: addEditNavigationController, action: #selector (AddEditNavigationController.cancelList))

        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Add", style: .plain, target: addEditNavigationController, action: #selector (AddEditNavigationController.toAdd)),
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector (onSave) )
        ]


        view.backgroundColor = UIColor.white
        listView = V1EditListView(frame: CGRect.zero)
        listView.items = self.items
        view.addSubview(listView)

        listView.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(view).offset(20)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view).offset(-20)
        }
    }

    func onSave() {
        print("Save List to database or server.")
        let info = AlistInfo(title: "I am a title", listType: "v1", from: LearnalistModel.getUUID())
        let aList = AlistV1(uuid: info.from!, info: info, data: listView.items)

        UIApplication.getModel().saveList(aList)

        (self.navigationController as! AddEditNavigationController).afterListSave()
    }

    func onSaveItem(data: String) {
        self.items.append(data)
        // This is required because we trigger add/edit to open before it has chance to load.
        if listView != nil {
            listView.setItems(items: items)
        }
        self.navigationController?.popViewController(animated: false)
    }
}
