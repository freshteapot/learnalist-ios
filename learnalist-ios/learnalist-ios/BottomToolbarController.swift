//
//  BottomToolBarController.swift
//  learnalist-ios
//
//  Created by Chris Williams on 26/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import Foundation
import UIKit

protocol BottomToolBarControllerDelegate: class {
    func onAdd()
    func onSplash()
    func onLastList()
}

public enum BottomToolBarAction : Int {
    case splash
    case lastList
    case add
}

class BottomToolBarController: UIView {
    let bottomView = UIView()
    weak var delegate: BottomToolBarControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func _init() {
        self.backgroundColor = UIColor.yellow

        
        let toolbar = UIToolbar()
        self.addSubview(toolbar)
        toolbar.snp.makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(self.snp.height)
        }
        
        let splashButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector (onSplash))

        let fillerButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let fillerButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let lastListButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fastForward, target: self, action: #selector (onLastList))
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector (onAdd))
        
        toolbar.items = [
            splashButton,
            fillerButton1,
            lastListButton,
            fillerButton2,
            addButton
        ]
        // [] -- [] -- []
        toolbar.sizeToFit()
    }
    
    func onSplash() {
        trigger(what:.splash)
    }

    func onAdd() {
        trigger(what:.add)
    }

    func onLastList() {
        trigger(what:.lastList)
    }

    func trigger(what: BottomToolBarAction) {
        if let topController = UIApplication.topViewController() {
            if let objectWith = topController as? BottomToolBarControllerDelegate {
                switch what {
                    case .splash:
                        objectWith.onSplash()
                    case .lastList:
                        objectWith.onLastList()
                    case .add:
                        objectWith.onAdd()
                    default:
                        print("Nothing is listening to the bottomtoolbar.")
                }
            }
        }
    }
}
