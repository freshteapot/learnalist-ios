//
//  ViewController.swift
//  learnalist-ios
//
//  Created by Chris Williams on 29/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {

    private var model:LearnalistModel!

    func getModel() -> LearnalistModel {
        return model
    }

    init(model:LearnalistModel) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = []


        // Create Tab one
        let tabMyList = TabMyListViewController()
        let tabMyListBarItem = UITabBarItem(title: tabMyList.titleToUse, image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))

        tabMyList.tabBarItem = tabMyListBarItem


        // Create Tab two
        let tabPickForAddEditList = TabPickViewController()
        let tabPickForAddEditListBarItem = UITabBarItem(title: tabPickForAddEditList.titleToUse, image: UIImage(named: "defaultImage2.png"), selectedImage: UIImage(named: "selectedImage2.png"))

        tabPickForAddEditList.tabBarItem = tabPickForAddEditListBarItem


        // Create Tab two
        let tabLastList = TabLastListViewController()
        let tabLastListBarItem = UITabBarItem(title: "Last List", image: UIImage(named: "defaultImage2.png"), selectedImage: UIImage(named: "selectedImage2.png"))

        tabLastList.tabBarItem = tabLastListBarItem

        self.viewControllers = [tabMyList, tabLastList, tabPickForAddEditList]
    }

    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title!)")
    }
}
