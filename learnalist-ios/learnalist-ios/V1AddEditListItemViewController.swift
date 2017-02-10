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
    let onSave = Signal<(index: Int, data: String)>()
    let onDelete = Signal<Int>()

    var index:Int = -1
    var rowData:String = ""

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    init(index: Int, rowData: String) {
        super.init(nibName: nil, bundle: nil)

        self.index = index
        self.rowData = rowData
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        let addEditNavigationController = self.navigationController as? AddEditNavigationController

        view.backgroundColor = UIColor.white

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "List", style: .plain, target: addEditNavigationController, action: #selector (AddEditNavigationController.toList))

        let editView = V1EditListViewItem(frame: CGRect.zero, rowData: self.rowData)
        editView.onSave.subscribe(on: self, callback: self.onSave)
        editView.onDelete.subscribe(on: self, callback: self.onDelete)
        view.addSubview(editView)

        editView.snp.makeConstraints{(make) -> Void in
            make.edges.equalTo(view)
            make.height.equalTo(view.snp.height)
        }
    }

    func onSave(data: String) {
        self.onSave.fire((index: self.index, data: data))
    }

    func onDelete(data: Bool) {
        self.onDelete.fire(self.index)
    }
}
