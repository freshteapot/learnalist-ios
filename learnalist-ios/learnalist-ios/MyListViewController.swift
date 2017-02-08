//  Created by Chris Williams on 29/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Dollar

class MyListViewController: UIViewController {
    var settings:SettingsInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        let model = UIApplication.getModel()
        settings = model.getSettings()
        let welcomeMessage = !settings.username.isEmpty ? "Hello \(settings.username)" : "Welcome, you have no lists."

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "settings", style: .plain, target: self, action: #selector (toSettings))

        self.navigationItem.title = "MyList"
        self.view.backgroundColor = UIColor.yellow

        let infoLabel = UILabel()
        infoLabel.backgroundColor = UIColor.lightGray
        infoLabel.text = welcomeMessage
        infoLabel.textAlignment = NSTextAlignment.center
        view.addSubview(infoLabel)

        infoLabel.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(view.snp.height).multipliedBy(0.1)
            make.top.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }

        let myListView = MyListView(frame: CGRect.zero)
        view.addSubview(myListView)

        myListView.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.right.equalTo(view).offset(-20)
            make.left.equalTo(view).offset(20)
            make.height.equalTo(view.snp.height).multipliedBy(0.8)
        }

        // This should get replaced, so we only read from database.
        let api = LearnalistApi(settings: settings)
        api.onResponse.subscribe(on: self) { response in
            if response.response?.statusCode == 200 {
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)

                    var items = [String]()
                    for (_, aList):(String, JSON) in json {
                        // Check to see if it is in the database?
                        if aList["info"]["type"].string! == "v1" {
                            if let test = AlistV1(json: JSONParseToDictionary(text: aList.rawString()!)!) {
                                items.append(test.info.title)
                                _ = JSONStringify(test.toJSON()!, pretty:true)
                            }
                        } else if aList["info"]["type"].string! == "v2" {
                            if let test = AlistV2(json: JSONParseToDictionary(text: aList.rawString()!)!) {
                                items.append(test.info.title)
                                _ = JSONStringify(test.toJSON()!, pretty:true)
                            }
                        }
                    }
                    myListView.setItems(items: items)
                }
            }
        }
        api.getMyLists()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func toSettings() {
        let vc = SettingsNavigationController()
        self.navigationController?.present(vc, animated: false,completion: nil)
    }
}
