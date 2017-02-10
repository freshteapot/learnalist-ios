//
//  V1EditlistViewItem.swift
//  learnalist-ios
//
//  Created by Chris Williams on 31/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import UIKit
import Signals

class V1EditListViewItem : UIView {

    let onSave = Signal<String>()
    let onDelete = Signal<Bool>()

    private var enableDismissKeyboard = false
    private var cleanedItem:String = ""
    private var saveButton:UIButton!
    private var itemField:UITextField!

    private var buttonSaveText = "Click to add to list"
    private var buttonEditText = "Add item"

    init(frame: CGRect, rowData: String) {
        super.init(frame: frame)

        if rowData != "" {
            buttonEditText = "Edit item"
            buttonSaveText = "Click to save changes"
        }

        saveButton = UIButton()
        saveButton.backgroundColor = UIColor.gray
        saveButton.setTitle(buttonEditText, for: UIControlState.normal)
        addSubview(saveButton)

        let deleteButton = UIButton()
        deleteButton.backgroundColor = UIColor.red
        deleteButton.setTitle("Delete Row", for: UIControlState.normal)

        if rowData == "" {
            deleteButton.isHidden = true
        }
        deleteButton.onTouchDown.subscribe(on: self) {
            self.onDelete.fire(true)
        }

        addSubview(deleteButton)

        itemField = UITextField()
        itemField.backgroundColor = UIColor.lightGray
        itemField.textAlignment = NSTextAlignment.center
        itemField.text = rowData

        addSubview(itemField)

        saveButton.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(self.snp.height).multipliedBy(0.1)
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        saveButton.onTouchDown.subscribe(on: self) {
            if self.enableDismissKeyboard {
                return
            }

            if !self.cleanedItem.isEmpty {
                self.onSave.fire(self.cleanedItem)
            }
        }

        deleteButton.snp.makeConstraints{(make) -> Void in
            make.bottom.equalTo(0).offset(-20)
            make.height.equalTo(self.snp.height).multipliedBy(0.1)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        itemField.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(saveButton.snp.bottom).offset(30)
            make.height.equalTo(self.snp.height).multipliedBy(0.2)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        itemField.onEditingDidBegin.subscribe(on: self) {
            self.enableDismissKeyboard = true
        }

        itemField.onEditingDidEndOnExit.subscribe(on: self) {
            print("onEditingDidEndOnExit")
            self.save(item: self.itemField.text!)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.enableDismissKeyboard {
            self.endEditing(true)
            self.save(item: itemField.text!)
        }
    }

    func save(item: String) {
        self.enableDismissKeyboard = false
        let cleaned = item.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleaned == "" {
            saveButton.setTitle(buttonEditText, for: UIControlState.normal)
            return
        }
        cleanedItem = cleaned
        saveButton.setTitle(buttonSaveText, for: UIControlState.normal)
    }
}
