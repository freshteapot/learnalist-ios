import UIKit

class V1EditListViewController: UIViewController {
    var listView:V1EditListView!
    var aList:AlistV1!

    init(aList: AlistV1) {
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
        listView = V1EditListView(frame: CGRect.zero, aList: self.aList)
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

    func onSave() {
        print("Save List to database or server.")
        UIApplication.getModel().saveList(self.aList)
        (self.navigationController as! AddEditNavigationController).afterListSave()
    }

    func onDeleteItem(index: Int) {
        self.aList.data.remove(at: index)
        listView.setItems(items: self.aList.data)
        self.navigationController!.popViewController(animated: false)
    }

    func onSaveItem(index: Int, data: String) {
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

    func onSaveInfo(data: AlistInfo) {
        self.aList.info = data
        listView.triggerListUpdate.fire(self.aList)
        self.navigationController!.popViewController(animated: false)
    }

    func onDeleteList(data: Bool) {
        UIApplication.getModel().deleteList(self.aList.uuid)
        self.navigationController!.dismiss(animated: false, completion: nil)
    }

    func onTitleAction(data: String) {
        if data == "open" {
            (self.navigationController as! AddEditNavigationController).toInfo(info: self.aList.info)
            return
        }
    }

    func onRowTap(index: Int) {
        var vc:V1AddEditListItemViewController!
        if index == -1 {
            vc = V1AddEditListItemViewController()
        } else {
            vc = V1AddEditListItemViewController(index: index, rowData: self.aList.data[index])
        }
        vc.onSave.subscribe(on: self, callback: onSaveItem)
        vc.onDelete.subscribe(on: self, callback: onDeleteItem)
        self.navigationController!.pushViewController(vc, animated: false)
    }
}
