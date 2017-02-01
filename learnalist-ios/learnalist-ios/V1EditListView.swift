//
//  V1EditListView.swift
//  learnalist-ios
//
//  Created by Chris Williams on 31/01/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import UIKit

class V1EditListView: UIView {
    override init (frame : CGRect) {
        super.init(frame : frame)

        let button = UIButton()
        button.backgroundColor = UIColor.gray
        button.setTitle("List View for v1", for: UIControlState.normal)

        addSubview(button)
        button.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(self.snp.height).multipliedBy(0.2)
            make.top.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
