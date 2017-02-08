//  Created by Chris Williams on 29/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import Foundation
import UIKit


class PickViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.navigationItem.title = "Pick"

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.red

        let pickInfoLabel = UILabel()
        pickInfoLabel.backgroundColor = UIColor.lightGray
        pickInfoLabel.text = "1st step, pick a list type."
        pickInfoLabel.textAlignment = NSTextAlignment.center
        view.addSubview(pickInfoLabel)

        pickInfoLabel.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(view.snp.height).multipliedBy(0.1)
            make.top.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }

        let pickView = PickView(frame: CGRect.zero)
        view.addSubview(pickView)

        pickView.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(pickInfoLabel.snp.bottom).offset(20)
            make.right.equalTo(view).offset(-20)
            make.left.equalTo(view).offset(20)
            make.height.equalTo(view.snp.height).multipliedBy(0.4)
        }

        pickView.onTap.subscribe(on: self) { (listType) in
            print("Goto list type: \(listType)")
            let vc = AddEditNavigationController(listType: listType, editType: "new")
            self.navigationController?.present(vc, animated: false,completion: nil)
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
