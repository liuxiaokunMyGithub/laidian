//
//  GBMineSectionHead1View.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/30.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBMineSectionHead1View: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(focusCountBtn)
        addSubview(fansCountBtn)
        addSubview(earningsCountBtn)
        addSubview(segmentateLine)
        addSubview(shareBtn)
        addSubview(arrowImageView)
        addSubview(line)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var onClickButton:((_ tag:Int)->())?

    lazy var focusCountBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth/3, height: 64)
        btn.tag = 1
        btn.setTitle("关注", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(kBaseColor, for: .selected)
        btn.addTarget(self, action: #selector(switchButtonAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var fansCountBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: kScreenWidth/3, y: 0, width: kScreenWidth/4, height: 64)
        btn.tag = 2
        btn.setTitle("粉丝", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(kBaseColor, for: .selected)
        btn.addTarget(self, action: #selector(switchButtonAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var earningsCountBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: kScreenWidth/3 * 2, y: 0, width: kScreenWidth/4, height: 64)
        btn.tag = 3
        btn.setTitle("收益", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(kBaseColor, for: .selected)
        btn.addTarget(self, action: #selector(switchButtonAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var segmentateLine:UIView = {
        let segmentateLine = UIView.init(frame: CGRect(x: 0, y: 64, width: kScreenWidth, height: 8))
        segmentateLine.backgroundColor = kSegmentateLineColor
        return segmentateLine
    }()
    
    lazy var shareBtn: UIButton = {
        let btn = GBLIRLButton.init(type: .custom)
        btn.frame = CGRect.init(x: GBMargin, y: 72, width: kScreenWidth, height: self.height-71)
        btn.tag = 4
        btn.setTitle("分享可赢取现金大礼包，赶紧来分享！", for: .normal)
        btn.setImage(UIImage(named: "icon_red packet"), for: .normal)
        btn.setTitleColor(kImportantTextColor, for: .normal)
        btn.titleLabel?.font = XKFont.pingFangSCRegular.size(13)
        btn.addTarget(self, action: #selector(switchButtonAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var arrowImageView:UIImageView = {
        let arrowImageView = UIImageView.init(frame: CGRect(x: kScreenWidth-12-GBMargin, y: 72, width: 12, height: 12))
        arrowImageView.image = UIImage.init(named: "icon_more_gray")
        arrowImageView.centerY = shareBtn.centerY
        return arrowImageView
    }()
    
    lazy var line:UIView = {
        let line = UIView.init(frame: CGRect(x: GBMargin, y: self.height-1, width: kScreenWidth - GBMargin*2, height: 1))
        line.backgroundColor = kLineColor
        return line
    }()
    
    // 按钮点击方法
    @objc func switchButtonAction(button:UIButton) {
        onClickButton!(button.tag)
    }

}
