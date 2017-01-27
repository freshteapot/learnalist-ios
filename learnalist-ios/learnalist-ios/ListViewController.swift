//
//  ListViewController.swift
//  learnalist-ios
//
//  Created by Chris Williams on 19/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import Foundation
import UIKit

protocol ListViewControllerDelegate: class {
    func listViewController(nameVC: ListViewController, didSaveName name: String)
}

class ListViewController: UIViewController {
    /*
     let lastNameTextField = UITextField()
     let firstNameTextField = UITextField()
     @IBOutlet weak var lastNameTextField: UITextField!
     @IBOutlet weak var firstNameTextField: UITextField!
     */
    weak var delegate: ListViewControllerDelegate?
    var fullName: String?
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(ListViewController.saveButtonTapped))
        self.navigationItem.title = "Edit Name"
        /*
         if let fullName = self.fullName? {
         let firstLast = fullName.componentsSeparatedByString(" ")
         firstNameTextField.text = firstLast[0]
         lastNameTextField.text = firstLast[1]
         }
         */
        
        view.backgroundColor = UIColor.red
        
        let topView = UIView()
        topView.backgroundColor = UIColor.blue
        
        let bottomLeftView = UIView()
        bottomLeftView.backgroundColor = UIColor.yellow
        
        let bottomRightView = UIView()
        bottomRightView.backgroundColor = UIColor.gray
        
        view.addSubview(topView)
        view.addSubview(bottomLeftView)
        view.addSubview(bottomRightView)
        
        //2
        topView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(0)
            make.height.equalTo(view.snp.height).multipliedBy(0.2)
        }
        
        //3
        bottomLeftView.snp.makeConstraints { (make) -> Void in
            make.left.bottom.equalTo(0)
            make.height.equalTo(view.snp.height).multipliedBy(0.1)
            make.width.equalTo(view.snp.width).multipliedBy(0.5)
        }
        //4
        bottomRightView.snp.makeConstraints { (make) -> Void in
            make.right.bottom.equalTo(0)
            make.height.equalTo(view.snp.height).multipliedBy(0.1)
            make.width.equalTo(view.snp.width).multipliedBy(0.5)
            
        }
    }
    
    func saveButtonTapped() {
        print("Save button tapped")
        //let name = firstNameTextField.text + " " + lastNameTextField.text
        let name = "chris"
        delegate?.listViewController(nameVC: self, didSaveName: name)
    }
}
