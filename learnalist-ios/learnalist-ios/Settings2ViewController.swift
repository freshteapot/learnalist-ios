//
//  Settings2ViewController.swift
//  learnalist-ios
//
//  Created by Chris Williams on 29/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//


import Foundation
import UIKit
import Signals

class Settings2ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = []

        view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))

        let button = UIButton()
        button.backgroundColor = UIColor.gray
        button.setTitle("Settings 2", for: UIControlState.normal)
        button.onTouchUpInside.subscribe(on: self) {
            // Handle the touch
            print("Go Back")
            self.navigationController?.popViewController(animated: false)
        }

        view.addSubview(button)
        button.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(view.snp.height).multipliedBy(0.2)
            make.top.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        print("HI")
        /*
         view.snp.makeConstraints{(make) -> Void in
         make.edges.equalTo(view.superview!).inset(UIEdgeInsetsMake(5, 10, 15, 20))
         }
         */
    }

    func cancelButtonTapped() {
        view.endEditing(true)
        print("Settings Cancel button tapped")

        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: false)
    }
}
