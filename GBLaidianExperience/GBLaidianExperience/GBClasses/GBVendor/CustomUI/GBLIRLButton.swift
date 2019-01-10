//
//  GBLIRLButton.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/31.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBLIRLButton: UIButton {
    var isShowCenter:Bool = false
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
        if isShowCenter == true {
            titleLabel?.centerX = self.width*0.5 + spaceWid
            imageView!.x = (titleLabel!.x - imageView!.width - spaceWid);
            
        }else {
            imageView!.frame.origin.x = 0
            titleLabel!.frame.origin.x = imageView!.frame.maxX + spaceWid
        }
    }


}
