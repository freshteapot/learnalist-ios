//
//  V1EditListViewController.swift
//  learnalist-ios
//
//  Created by Chris Williams on 31/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import UIKit

class V2EditListViewController: UIViewController {
    var listView:V2EditListView!
    var aList:AlistV2!

    init(aList: AlistV2) {
        super.init(nibName: nil, bundle: nil)
        self.aList = aList
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        listView = V2EditListView(frame: CGRect.zero, aList: self.aList)
        listView.onTitleAction.subscribe(on: self, callback: self.onTitleAction)
        listView.onRowTap.subscribe(on: self, callback: self.onRowTap)
        view.addSubview(listView)

        listView.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(view).offset(20)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view).offset(-20)
        }
    }

    // This is generic
    func onSave() {
        UIApplication.getModel().saveList(self.aList)
        (self.navigationController as! AddEditNavigationController).afterListSave()
    }

    // This is generic
    func onDeleteItem(index: Int) {
        self.aList.data.remove(at: index)
        listView.setItems(items: self.aList.data)
        self.navigationController!.popViewController(animated: false)
    }

    // This is generic
    func onSaveItem(index: Int, data: AlistV2Row) {
        if index == -1 {
            self.aList.data.append(data)
        } else {
            self.aList.data[index] = data
        }

        // This is required because we trigger add/edit to open before it has chance to load.
        if listView != nil {
            listView.triggerListUpdate.fire(self.aList)
        }
        self.navigationController!.popViewController(animated: false)
    }

    // This is generic
    func onSaveInfo(data: AlistInfo) {
        self.aList.info = data
        listView.triggerListUpdate.fire(self.aList)
        self.navigationController!.popViewController(animated: false)
    }

    // This is generic
    func onDeleteList(data: Bool) {
        UIApplication.getModel().deleteList(self.aList.uuid)
        self.navigationController!.dismiss(animated: false, completion: nil)
    }

    // This is generic
    func onTitleAction(data: String) {
        if data == "open" {
            (self.navigationController as! AddEditNavigationController).toInfo(info: self.aList.info)
            return
        }
    }

    func onRowTap(index: Int) {
        var vc:V2AddEditListItemViewController!
        if index == -1 {
            vc = V2AddEditListItemViewController()
        } else {
            vc = V2AddEditListItemViewController(index: index, rowData: self.aList.data[index])
        }
        vc.onSave.subscribe(on: self, callback: onSaveItem)
        vc.onDelete.subscribe(on: self, callback: onDeleteItem)
        self.navigationController!.pushViewController(vc, animated: false)
    }
}
