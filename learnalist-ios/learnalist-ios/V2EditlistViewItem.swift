//
//  V1EditlistViewItem.swift
//  learnalist-ios
//
//  Created by Chris Williams on 31/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import UIKit
import Signals

class V2EditListViewItem : UIView {

    let onTap = Signal<(from:String, to:String)>()

    private var cleanedItemFrom = ""
    private var cleanedItemTo = ""
    private var button:UIButton = UIButton()

    private let buttonSaveText = "Click to save to list"
    private let buttonEditText = "Add or Edit item"

    override init (frame : CGRect) {
        super.init(frame : frame)

        button = UIButton()
        button.backgroundColor = UIColor.gray
        button.setTitle(buttonEditText, for: UIControlState.normal)

        addSubview(button)


        let itemFieldFrom = UITextField()
        itemFieldFrom.backgroundColor = UIColor.lightGray
        itemFieldFrom.textAlignment = NSTextAlignment.center
        addSubview(itemFieldFrom)

        let itemFieldTo = UITextField()
        itemFieldTo.backgroundColor = UIColor.lightGray
        itemFieldTo.textAlignment = NSTextAlignment.center
        addSubview(itemFieldTo)

        button.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(self.snp.height).multipliedBy(0.2)
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        button.onTouchDown.subscribe(on: self) {
            if !self.cleanedItemFrom.isEmpty && !self.cleanedItemTo.isEmpty {
                self.onTap.fire((from: self.cleanedItemFrom, to: self.cleanedItemTo))
            }
        }

        itemFieldFrom.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(button.snp.bottom).offset(30)
            make.height.equalTo(self.snp.height).multipliedBy(0.3)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        itemFieldTo.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(itemFieldFrom.snp.bottom).offset(20)
            make.height.equalTo(self.snp.height).multipliedBy(0.3)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        itemFieldFrom.onEditingDidEndOnExit.subscribe(on: self) {
            self.save(item: itemFieldFrom.text!, what: "from")
        }

        itemFieldFrom.onTouchUpOutside.subscribe(on: self) {
            self.save(item: itemFieldFrom.text!, what: "from")
        }

        itemFieldTo.onEditingDidEndOnExit.subscribe(on: self) {
            self.save(item: itemFieldTo.text!, what: "to")
        }

        itemFieldTo.onTouchUpOutside.subscribe(on: self) {
            self.save(item: itemFieldTo.text!, what: "to")
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }

    func save(item: String, what: String) {
        let cleaned = item.trimmingCharacters(in: .whitespacesAndNewlines)

        if what == "from" {
            cleanedItemFrom = cleaned
        } else if what == "to" {
            cleanedItemTo = cleaned
        }

        if !cleanedItemFrom.isEmpty && !cleanedItemTo.isEmpty {
            button.setTitle(buttonSaveText, for: UIControlState.normal)
            return
        }
        button.setTitle(buttonEditText, for: UIControlState.normal)
    }
}
