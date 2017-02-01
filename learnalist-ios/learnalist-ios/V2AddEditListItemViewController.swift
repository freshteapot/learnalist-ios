//  Created by Chris Williams on 31/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import UIKit

class V2AddEditListItemViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        let addEditNavigationController = self.navigationController as? AddEditNavigationController

        view.backgroundColor = UIColor.white

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "List", style: .plain, target: addEditNavigationController, action: #selector (AddEditNavigationController.toList))

        let editView = V2EditListViewItem(frame: CGRect.zero)
        view.addSubview(editView)

        editView.snp.makeConstraints{(make) -> Void in
            make.top.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }


        editView.onTap.subscribe(on: self) { (from, to) in
            print("Save item: from -> \(from) to -> \(to)")
            print("Save, then render new table")
            addEditNavigationController?.toList()
        }
    }
}
