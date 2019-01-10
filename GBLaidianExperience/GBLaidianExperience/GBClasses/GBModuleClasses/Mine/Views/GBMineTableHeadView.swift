//
//  GBMineTableHeadView.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/30.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBMineTableHeadView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        topView.addSubview(iconView)
        iconView.center = CGPoint(x: topView.center.x, y: topView.center.y - 10)
        topView.addSubview(nameLabel)
        nameLabel.frame = CGRect(x: 0, y: iconView.frame.size.height+iconView.frame.origin.y+6, width: kScreenWidth, height: 19)
        topView.addSubview(fansLabel)
        fansLabel.frame = CGRect(x: 0, y: nameLabel.frame.origin.y+19+5, width: kScreenWidth, height: 16)
        topView.addSubview(detailLabel)
        detailLabel.frame = CGRect(x: 0, y: fansLabel.frame.origin.y+16+5, width: kScreenWidth, height: 15)
        
        addSubview(topView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var iconView:UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "img_default"))
        imgView.frame.size = CGSize(width: 80, height: 80)
        imgView.layer.borderColor = UIColor.white.cgColor
        imgView.layer.borderWidth = 2
        imgView.layer.cornerRadius = 40
        imgView.layer.masksToBounds = true
        return imgView
    }()
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "003"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    lazy var fansLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "关注 121  |  粉丝 891"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    lazy var detailLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "简介:隔壁科技有限公司，来点经验APP iOS工程师"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    lazy var topView:UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "wbBg"))
        imgView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: self.height)
        imgView.contentMode = UIView.ContentMode.scaleAspectFill
        imgView.clipsToBounds = true
        imgView.backgroundColor = kBaseColor
        return imgView
    }()
}
