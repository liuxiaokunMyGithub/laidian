//
//  GBLLRIButton.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/31.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBLLRIButton: UIButton {
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
        //btn的宽度
        let btnWid = frame.size.width
        //titleLabel ,imageView的总宽度 加 空隙
        let wid = titleLabel!.frame.size.width + imageView!.frame.size.width + spaceWid
        
        titleLabel!.frame.origin.x = (btnWid-wid)*0.5
        imageView!.frame.origin.x = titleLabel!.frame.maxX + spaceWid
    }
    
    
}
