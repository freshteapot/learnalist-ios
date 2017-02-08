//
//  AddEditNavigationController.swift
//  learnalist-ios
//
//  Created by Chris Williams on 31/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import UIKit

class AddEditNavigationController: UINavigationController, UINavigationControllerDelegate {
    var listType:String = "v0"
    var editType:String = "new"

    init(listType: String, editType: String) {
        super.init(nibName: nil, bundle: nil)
        self.listType = listType
        self.editType = editType
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.delegate = self

        if listType == "v1" {
            let vc = V1EditListViewController()
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

    func toAdd() {
        print("To Add from AddEditNaviationController.")
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
