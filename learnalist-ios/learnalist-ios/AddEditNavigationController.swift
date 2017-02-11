import UIKit

class AddEditNavigationController: UINavigationController, UINavigationControllerDelegate {
    var listType:String = "v0"
    var editType:String = "new"
    var uuid:String!

    init(uuid: String, listType: String) {
        super.init(nibName: nil, bundle: nil)
        self.listType = listType
        self.editType = "edit"
        self.uuid = uuid
    }

    init(listType: String, editType: String) {
        super.init(nibName: nil, bundle: nil)
        self.listType = listType
        self.editType = editType
        self.uuid = LearnalistModel.getUUID()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.delegate = self
        let model = UIApplication.getModel()

        // There is a chance that the uuid is not uuid and is from_uuid. If a bug appears, it might be linked to this.
        if listType == "v1" {
            let aList = (self.editType == "edit") ? model.getListByUuid(self.uuid) : AlistV1.NewList(self.uuid)

            let vc = V1EditListViewController(
                aList: aList as! AlistV1
            )
            self.setViewControllers([vc], animated: false)
        } else if listType == "v2" {
            let vc = V2AddEditListItemViewController()
            self.setViewControllers([vc], animated: false)
        } else {
            print("@Todo")
            return
        }

        if self.editType == "new" {
            self.toAdd()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("in: didShow")
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("in: willShow")
        viewController.edgesForExtendedLayout = []
    }

    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("in: animationController UINavigationControllerOperation")
        return nil
    }

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        print("in: animationController UIViewControllerAnimatedTransitioning")
        return nil
    }

    func cancelList() {
        view.endEditing(true)
        print("Cancel List from AddEditNaviationController.")
        self.dismiss(animated: false, completion: nil)
    }

    func afterListSave() {
        print("After List Save from AddEditNaviationController.")
        self.dismiss(animated: false, completion: nil)
    }

    func toList() {
        print("To List from AddEditNaviationController.")
        if listType == "v1" {
            self.popViewController(animated: false)
        } else if listType == "v2" {
            self.popViewController(animated: false)
        } else {
            print("@Todo")
        }
    }

    func toInfo(info: AlistInfo) {
        let vc = EditListInfoViewController(info: info)
        if listType == "v1" {
            vc.onSave.subscribe(on: self, callback: (self.topViewController as! V1EditListViewController).onSaveInfo)
            vc.onDelete.subscribe(on: self, callback: (self.topViewController as! V1EditListViewController).onDeleteList)
        } else if listType == "v2" {
            // vc.onSave.subscribe(on: self, callback: (self.topViewController as! V2EditListViewController).onSaveInfo)
        } else {
            print("@Todo")
        }

        self.pushViewController(vc, animated: false)
    }

    func toAdd() {
        if listType == "v1" {
            let vc = V1AddEditListItemViewController()
            vc.onSave.subscribe(on: self, callback: (self.topViewController as! V1EditListViewController).onSaveItem)
            self.pushViewController(vc, animated: false)
        } else if listType == "v2" {
            let vc = V2AddEditListItemViewController()
            self.pushViewController(vc, animated: false)
        } else {
            print("@Todo")
        }
    }
}
