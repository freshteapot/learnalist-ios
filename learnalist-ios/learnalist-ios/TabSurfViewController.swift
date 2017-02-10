import Foundation
import UIKit

class TabSurfViewController: UINavigationController, UINavigationControllerDelegate {

    let titleToUse = "Surf"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []

        self.view.backgroundColor = UIColor.black
        self.title = titleToUse

        let vc = SurfViewController()
        self.setViewControllers([vc], animated: false)
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
