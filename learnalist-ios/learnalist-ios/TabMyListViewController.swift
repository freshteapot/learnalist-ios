//  Created by Chris Williams on 29/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import Foundation
import UIKit

class TabMyListViewController: UINavigationController, UINavigationControllerDelegate {
    let titleToUse = "My List"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.yellow
        self.title = titleToUse

        let vc = MyListViewController()
        self.setViewControllers([vc], animated: false)
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
