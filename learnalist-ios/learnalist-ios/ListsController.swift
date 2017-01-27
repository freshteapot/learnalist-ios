//
//  ListsController.swift
//  learnalist-ios
//
//  Created by Chris Williams on 19/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import Foundation
import UIKit

class ListsController: UIViewController, UITableViewDataSource, UITableViewDelegate, ListViewControllerDelegate,
SettingsControllerDelegate {
    var model = Model()

    var settingsInfo = SettingsInfo(username:"", password:"")

    var names = ["Brent Berg", "Cody Preston", "Kareem Dixon", "Xander Clark",
                 "Francis Frederick", "Carson Hopkins", "Anthony Nguyen", "Dean Franklin",
                 "Jeremy Davenport", "Rigel Bradford", "John Ball", "Zachery Norman",
                 "Valentine Lindsey", "Slade Thornton", "Jelani Dickson", "Vance Hurley",
                 "Wayne Ellison", "Kasimir Mueller", "Emery Pruitt", "Lucius Lawrence",
                 "Kenneth Mendez"]
    
    var tableView: UITableView!
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Lists"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(ListsController.rightButtonTapped))
        
        tableView = UITableView(frame: view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NameCell")
        view.addSubview(tableView)
        
        settingsInfo = model.getSettings()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell")! as UITableViewCell
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let listVC = ListViewController()
        listVC.delegate = self
        
        selectedIndexPath = indexPath
        tableView.deselectRow(at: indexPath as IndexPath, animated: false)
        self.navigationController?.pushViewController(listVC, animated: false)
    }

    func listViewController(nameVC: ListViewController, didSaveName name: String) {
        if let indexPath = selectedIndexPath {
            print(indexPath)
            //names[indexPath.row] = name
            //tableView.reloadRows(at: [indexPath as IndexPath], with: .automatic)
        }
        self.navigationController?.popViewController(animated: false)
    }
    
    func settingsController(nameVC: SettingsController, didSaveName info: SettingsInfo) {
        print(info) 
        model.saveSettings(settings: info)
        settingsInfo = info
        self.navigationController?.popViewController(animated: true)

    }

    func rightButtonTapped() {
        print("right button tapped")
        model.getSettings()
        let settingsVC = SettingsController(info: settingsInfo)
        settingsVC.delegate = self
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
}

