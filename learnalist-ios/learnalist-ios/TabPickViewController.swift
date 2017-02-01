//  Created by Chris Williams on 29/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import Foundation
import UIKit

class TabPickViewController: UINavigationController, UINavigationControllerDelegate {
    let titleToUse = "Add"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow
        self.title = titleToUse

        self.edgesForExtendedLayout = []


        let vc = PickViewController()
        self.setViewControllers([vc], animated: false)

        self.delegate = self

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

}
