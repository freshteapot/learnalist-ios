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

    let onTap = Signal<String>()

    private var cleanedItem:String = ""
    private var button:UIButton = UIButton()

    private let buttonSaveText = "Click to save to list"
    private let buttonEditText = "Add or Edit item"

    override init (frame : CGRect) {
        super.init(frame : frame)

        button = UIButton()
        button.backgroundColor = UIColor.gray
        button.setTitle(buttonEditText, for: UIControlState.normal)

        addSubview(button)


        let itemField = UITextField()
        itemField.backgroundColor = UIColor.lightGray
        itemField.textAlignment = NSTextAlignment.center

        addSubview(itemField)

        button.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(self.snp.height).multipliedBy(0.2)
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        button.onTouchDown.subscribe(on: self) {
            if !self.cleanedItem.isEmpty {
                self.onTap.fire(self.cleanedItem)
            }
        }

        itemField.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(button.snp.bottom).offset(30)
            make.height.equalTo(self.snp.height).multipliedBy(0.3)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        itemField.onEditingDidEndOnExit.subscribe(on: self) {
            self.save(item: itemField.text!)
        }


        itemField.onTouchUpOutside.subscribe(on: self) {
            self.save(item: itemField.text!)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }

    func save(item: String) {
        let cleaned = item.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleaned == "" {
            button.setTitle(buttonEditText, for: UIControlState.normal)
            return
        }
        cleanedItem = cleaned
        button.setTitle(buttonSaveText, for: UIControlState.normal)
    }
}
