//
//  V1EditListView.swift
//  learnalist-ios
//
//  Created by Chris Williams on 31/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import UIKit

class V1EditListView: UIView, UITableViewDataSource, UITableViewDelegate {
    var items = [String]()
    var tableView: UITableView!

    override init (frame : CGRect) {
        super.init(frame : frame)
        backgroundColor = UIColor.yellow

        let button = UIButton()
        button.backgroundColor = UIColor.gray
        button.setTitle("Save List", for: UIControlState.normal)

        addSubview(button)
        button.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(self.snp.height).multipliedBy(0.05)
            make.top.left.equalTo(self)
            make.right.equalTo(self)
        }

        let titleButton = UIButton()
        titleButton.backgroundColor = UIColor.gray
        titleButton.setTitle("title:", for: UIControlState.normal)
        titleButton.contentHorizontalAlignment = .left

        addSubview(titleButton)
        titleButton.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(button.snp.bottom).offset(5)
            make.height.equalTo(self.snp.height).multipliedBy(0.1)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }



        tableView = UITableView(frame: frame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false

        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44;
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NameCell")
        addSubview(tableView)

        tableView.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(titleButton.snp.bottom).offset(10)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell")! as UITableViewCell
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("do: Goto list view.")
        tableView.deselectRow(at: indexPath as IndexPath, animated: false)
    }

    func setItems(items: [String]) {
        self.items = items
        tableView.reloadData()
    }
}
