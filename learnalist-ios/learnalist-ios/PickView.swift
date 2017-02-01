//
//  PickView.swift
//  learnalist-ios
//
//  Created by Chris Williams on 31/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//
import UIKit
import Signals

class PickView: UIView, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView!
    var selectedIndexPath: IndexPath?
    var items:[String] = ["v1", "v2"]

    let onTap = Signal<String>()

    override init (frame : CGRect) {
        super.init(frame : frame)

        self.backgroundColor = UIColor.red

        tableView = UITableView(frame: frame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false

        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44;

        tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        tableView.estimatedSectionHeaderHeight = 30;

        tableView.sectionFooterHeight = UITableViewAutomaticDimension;
        tableView.estimatedSectionFooterHeight = 30;

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NameCell")
        addSubview(tableView)
        tableView.snp.makeConstraints{(make) -> Void in
            make.edges.equalToSuperview()
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
        let listType = items[indexPath.row]
        print("do: will goto add/edit item for this type: \(listType)")
        selectedIndexPath = indexPath
        tableView.deselectRow(at: indexPath as IndexPath, animated: false)
        onTap.fire(listType)
    }


    func onAdd() {
        print("onAdd: do nothing")
    }

    func onSplash() {
        print("onSplash: change to splash")
        //let vc = UIApplication.getSplash()
        //self.navigationController?.setViewControllers([vc], animated: false)
    }

    func onLastList() {
        print("onLastList")
        //let vc = UIApplication.getLastList()
        //self.navigationController?.setViewControllers([vc], animated: false)
    }
}
