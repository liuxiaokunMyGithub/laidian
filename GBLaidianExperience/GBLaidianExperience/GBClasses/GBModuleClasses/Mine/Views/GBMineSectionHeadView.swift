//
//  GBMineSectionHeadView.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/30.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBMineSectionHeadView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(publishCountBtn)
        addSubview(commentsCountBtn)
        addSubview(usefulCountBtn)
        addSubview(collectionCountBtn)
        addSubview(segmentateLine)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     lazy var publishCountBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth/4, height: self.height-8)
        btn.tag = 1
        btn.setTitle("发布", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(kBaseColor, for: .selected)
        btn.addTarget(self, action: #selector(switchButtonAction), for: .touchUpInside)
        return btn
        }()
    
    lazy var commentsCountBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: kScreenWidth/4, y: 0, width: kScreenWidth/4, height: self.height-8)
        btn.tag = 2
        btn.setTitle("评论", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(kBaseColor, for: .selected)
        btn.addTarget(self, action: #selector(switchButtonAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var usefulCountBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: kScreenWidth/4 * 2, y: 0, width: kScreenWidth/4, height: self.height-8)
        btn.tag = 3
        btn.setTitle("有用", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(kBaseColor, for: .selected)
        btn.addTarget(self, action: #selector(switchButtonAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var collectionCountBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: kScreenWidth/4 * 3, y: 0, width: kScreenWidth/4, height: self.height-8)
        btn.tag = 4
        btn.setTitle("收藏", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(kBaseColor, for: .selected)
        btn.addTarget(self, action: #selector(switchButtonAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var segmentateLine:UIView = {
        let segmentateLine = UIView.init(frame: CGRect(x: 0, y: self.height-8, width: kScreenWidth, height: 8))
        segmentateLine.backgroundColor = kSegmentateLineColor
        return segmentateLine
    }()
    
    // 按钮点击方法
    @objc func switchButtonAction(button:UIButton) {
        switch button.tag {
        case 1:
            GBLog(1)
        case 2:
            GBLog(2)
        case 3:
            GBLog(3)
        case 4:
            GBLog(4)
        default:
            break
        }
    }
    
   
}
