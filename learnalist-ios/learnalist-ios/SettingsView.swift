//
//  SettingsView.swift
//  learnalist-ios
//
//  Created by Chris Williams on 01/02/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import UIKit
import Signals
import Alamofire
import SwiftyJSON

class SettingsView: UIView {

    let onTap = Signal<String>()
    var settingsInfo:SettingsInfo!
    var button:UIButton!

    private let buttonSaveText = "Click to save settings"
    private let buttonTestAccess = "Click to test connection."
    private let buttonEditText = "Add Username and password to access api."

    let usernameField = UITextField()
    let passwordField = UITextField()

    let userNamePlaceholder = "Enter username"
    let passwordPlaceholder = "Enter password"
    let passwordHideTextHolder = "********"

    override init (frame : CGRect) {
        super.init(frame : frame)
        let model = UIApplication.getModel()
        settingsInfo = model.getSettings()

        self.backgroundColor = UIColor.red

        button = UIButton()
        button.backgroundColor = UIColor.gray
        if (!settingsInfo.username.isEmpty && !settingsInfo.password.isEmpty) {
            button.setTitle(buttonTestAccess, for: UIControlState.normal)
        } else {
            button.setTitle(buttonEditText, for: UIControlState.normal)
        }
        addSubview(button)

        button.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(self.snp.height).multipliedBy(0.1)
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        button.onTouchDown.subscribe(on: self) {
            if self.button.currentTitle == self.buttonTestAccess {
                print("Test connection \(self.settingsInfo)")
                self.testConnection()
            }

            if self.button.currentTitle == self.buttonSaveText {
                model.saveSettings(settings: self.settingsInfo)
                self.onTap.fire("Done")
            }
        }

        usernameField.backgroundColor = UIColor.lightGray
        usernameField.textAlignment = NSTextAlignment.center
        if (!settingsInfo.username.isEmpty) {
            usernameField.text = settingsInfo.username
        } else {
            usernameField.text = userNamePlaceholder
            usernameField.textColor = UIColor.lightGray
        }
        addSubview(usernameField)

        if (!settingsInfo.username.isEmpty) {
            passwordField.text = passwordHideTextHolder
        } else {
            passwordField.text = passwordPlaceholder
            passwordField.textColor = UIColor.lightGray
        }
        passwordField.backgroundColor = UIColor.lightGray
        passwordField.textAlignment = NSTextAlignment.center
        addSubview(passwordField)


        usernameField.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(button.snp.bottom).offset(30)
            make.height.equalTo(self.snp.height).multipliedBy(0.3)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        passwordField.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(usernameField.snp.bottom).offset(20)
            make.height.equalTo(self.snp.height).multipliedBy(0.3)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        usernameField.onEditingDidEndOnExit.subscribe(on: self) {
            self.save(textField: self.usernameField)
        }

        usernameField.onTouchUpOutside.subscribe(on: self) {
            self.save(textField: self.usernameField)
        }

        passwordField.onEditingDidBegin.subscribe(on: self) {
            self.passwordField.text = ""
        }

        passwordField.onEditingDidEndOnExit.subscribe(on: self) {
            self.save(textField: self.passwordField)
        }

        passwordField.onTouchUpOutside.subscribe(on: self) {
            self.save(textField: self.passwordField)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }

    func save(textField: UITextField) {
        if var value = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
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
                textField.text = passwordHideTextHolder
                settingsInfo.password = value
            }
            button.setTitle(buttonTestAccess, for: UIControlState.normal)
        }
    }

    func testConnection() {
        //view.addSubview(container)
        // @todo create a simple api to test connection
        let url = "https://learnalist.net/api/alist/by/me"
        let user = settingsInfo.username
        let password = settingsInfo.password

        self.button.isEnabled = false
        Alamofire.request(url, method: .get)
            .authenticate(user: user, password: password)
            .responseJSON { response in
                if response.response?.statusCode == 200 {
                    self.button.setTitle(self.buttonSaveText, for: UIControlState.normal)
                }
                self.button.isEnabled = true
        }

    }
}
