//  Created by Chris Williams on 31/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import UIKit
import Signals

class V2AddEditListItemViewController: UIViewController {
    let onSave = Signal<(index: Int, data: AlistV2Row)>()
    let onDelete = Signal<Int>()

    var index:Int = -1
    var rowData:AlistV2Row = AlistV2Row(from:"", to:"")

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    init(index: Int, rowData: AlistV2Row) {
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

        let editView = V2EditListViewItem(frame: CGRect.zero, rowData: self.rowData)
        editView.onSave.subscribe(on: self, callback: self.onSave)
        editView.onDelete.subscribe(on: self, callback: self.onDelete)

        view.addSubview(editView)

        editView.snp.makeConstraints{(make) -> Void in
            make.edges.equalTo(view)
            make.height.equalTo(view.snp.height)
        }
    }

    func onSave(data: AlistV2Row) {
        self.onSave.fire((index: self.index, data: data))
    }

    func onDelete(data: Bool) {
        self.onDelete.fire(self.index)
    }
}
