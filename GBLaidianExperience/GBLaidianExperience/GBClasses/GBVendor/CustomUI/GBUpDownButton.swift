//
//  GBUpDownButton.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/30.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBUpDownButton: UIButton {
    //MARK:- 重写init函数
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //titleLabel ,imageView中间的空隙宽度
        let spaceWid = CGFloat(5)
        let imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.width)
        let titleRect = CGRect(x: 0, y: self.size.width+spaceWid, width: self.size.width, height: self.size.height - self.size.width)
        imageView?.frame = imageRect
        titleLabel?.frame = titleRect
    }
    
}

