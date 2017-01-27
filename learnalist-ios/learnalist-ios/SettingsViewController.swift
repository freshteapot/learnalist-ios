//
//  SettingsViewController.swift
//  learnalist-ios
//
//  Created by Chris Williams on 27/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, BottomToolBarControllerDelegate, UITextFieldDelegate {
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SettingsViewController.cancelButtonTapped))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(SettingsViewController.saveButtonTapped))
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
        if var value = textField.text {
            if (value.isEmpty) {
                if (usernameField == textField) {
                    textField.text = userNamePlaceholder
                } else if (passwordField == textField) {
                    textField.text = passwordPlaceholder
                }
                textField.textColor = UIColor.lightGray
            }

            value = value.trimmingCharacters(in: .whitespacesAndNewlines)

            if (usernameField == textField) {
                settingsInfo.username = value
            } else if (passwordField == textField) {
                settingsInfo.password = value
            }
        }
        
    }
    
    func cancelButtonTapped() {
        view.endEditing(true)
        print("Settings Cancel button tapped")
        print("Do not save the settings.")
        let vc = UIApplication.getSplash()
        self.navigationController?.setViewControllers([vc], animated: false)
    }
    
    func saveButtonTapped() {
        view.endEditing(true)
        print("Settings Save button tapped")
        print("Would need to check this works.")
        var model = Model()
        model.saveSettings(settings: settingsInfo)
        let vc = UIApplication.getSplash()
        self.navigationController?.setViewControllers([vc], animated: false)
    }
    
    
    func onAdd() {
        print("onAdd: do nothing")
    }
    
    func onSplash() {
        print("onSplash: change to splash")
        let vc = UIApplication.getSplash()
        self.navigationController?.setViewControllers([vc], animated: false)
    }
    
    func onLastList() {
        print("onLastList")
        let vc = UIApplication.getLastList()
        self.navigationController?.setViewControllers([vc], animated: false)
    }
}
