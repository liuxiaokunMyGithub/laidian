//
//  CustomNineViewItem.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/8.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

import UIKit

class CustomNineViewItem: UIView {

    lazy var titleButton:UIButton = {
       let button = UIButton()
        button.contentHorizontalAlignment = .center
       return button
    }()
    lazy var subTitleButton:UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleButton)
        self.addSubview(subTitleButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleButton.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height/2)
        subTitleButton.frame = CGRect(x: 0, y: self.height/2, width: self.width, height: self.height/2)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
