//
//  SettingsController.swift
//  learnalist-ios
//
//  Created by Chris Williams on 19/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import Foundation
import UIKit


protocol SettingsControllerDelegate: class {
    func settingsController(nameVC: SettingsController, didSaveName info: SettingsInfo)
}

class SettingsController: UIViewController, UITextFieldDelegate {
    weak var delegate: SettingsControllerDelegate?
    //@load this from the db
    // var settingsInfo = SettingsInfo(username:"", password:"")
    var settingsInfo: SettingsInfo

    let usernameField = UITextField()
    let passwordField = UITextField()

    let userNamePlaceholder = "Enter username"
    let passwordPlaceholder = "Enter password"
    
    init(info:SettingsInfo) {
        settingsInfo = info
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(SettingsController.saveButtonTapped))
        self.navigationItem.title = "Settings"
        
        
        view.backgroundColor = UIColor.red
        
        let topView = UIView()
        topView.backgroundColor = UIColor.blue
        let topView2 = UIView()
        topView2.backgroundColor = UIColor.green
        
        let usernameView = makeUsernameView()
        let passwordView = makePasswordView()

        let bottomLeftView = UIView()
        bottomLeftView.backgroundColor = UIColor.yellow
        
        let bottomRightView = UIView()
        bottomRightView.backgroundColor = UIColor.gray
        
        view.addSubview(topView)
        view.addSubview(topView2)
        view.addSubview(usernameView)
        view.addSubview(passwordView)
        view.addSubview(bottomLeftView)
        view.addSubview(bottomRightView)

        let navBarHeight = self.navigationController!.navigationBar.frame.size.height

        //2
        topView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(0).offset(navBarHeight)
            make.left.right.equalTo(0)
            make.height.equalTo(view.snp.height).multipliedBy(0.2)
        }
        
        usernameView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(0)
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(view.snp.height).multipliedBy(0.1)
        }
        
        passwordView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(0)
            make.top.equalTo(usernameView.snp.bottom)
            make.height.equalTo(view.snp.height).multipliedBy(0.1)
        }
        
        topView2.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(0)
            make.height.equalTo(view.snp.height).multipliedBy(0.2)
            make.top.equalTo(passwordView.snp.bottom)
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
    
    func makeUsernameView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white

        if (!settingsInfo.username.isEmpty) {
            usernameField.text = settingsInfo.username
        } else {
            usernameField.text = userNamePlaceholder
            usernameField.textColor = UIColor.lightGray
        }

        
        view.addSubview(usernameField)
        usernameField.delegate = self
        usernameField.snp.makeConstraints { (make) -> Void in
            make.top.right.equalTo(0)
            make.height.equalTo(view.snp.height)
            make.center.equalTo(view)
        }

        return view;
    }

    func makePasswordView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        if (!settingsInfo.username.isEmpty) {
            passwordField.text = settingsInfo.password
        } else {
            passwordField.text = passwordPlaceholder
            passwordField.textColor = UIColor.lightGray
        }

        view.addSubview(passwordField)
        passwordField.delegate = self
        passwordField.snp.makeConstraints { (make) -> Void in
            make.top.right.equalTo(0)
            make.height.equalTo(view.snp.height)
            make.center.equalTo(view)
        }
        
        return view;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.lightGray {
            textField.text = nil
            textField.textColor = UIColor.black
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        
    }

    func saveButtonTapped() {
        delegate?.settingsController(nameVC: self, didSaveName: settingsInfo)
    }
}
