//
//  GBSexSettingCell.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/2.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBSexSettingCell: GBBaseTableViewCell {
    // 性别
    enum Sex: Int {
        case men = 1
        case women = 2
    }
    
    var didSelectSexBlock:((_ sex:String) -> ())?
    
    lazy var menButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.tag = Sex.men.rawValue
        btn.setImage(UIImage(named: "icon_men_gray"), for: .normal)
        btn.setImage(UIImage(named: "icon_men_blue"), for: .selected)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(switchButtonAction), for: .touchUpInside)
        return btn
    }()
    lazy var womenButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.tag = Sex.women.rawValue
        btn.setImage(UIImage(named: "icon_women_gray"), for: .normal)
        btn.setImage(UIImage(named: "icon_women_red"), for: .selected)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(switchButtonAction), for: .touchUpInside)
        return btn
    }()
    
    @objc func switchButtonAction(tag:Int) {
        switch tag {
        case Sex.men.rawValue:
            self.menButton.isSelected = true
            self.womenButton.isSelected = false
            self.didSelectSexBlock!("男")
            break
        case Sex.women.rawValue:
            self.menButton.isSelected = false
            self.womenButton.isSelected = true
            self.didSelectSexBlock!("女")
            break
        default:
            break
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(baseTitleLabel)
        addSubview(baseLineView)
        addSubview(menButton)
        addSubview(womenButton)
        
        baseTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(GBMargin)
            make.centerY.equalTo(self);
        }
        
        baseLineView.snp.makeConstraints { (make) in
            make.left.equalTo(GBMargin);
            make.right.equalTo(self).offset(-GBMargin);
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
        
        womenButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-GBMargin)
            make.size.equalTo(CGSize(width: 34, height: 34))
            make.centerY.equalTo(self)
        }
        
        menButton.snp.makeConstraints { (make) in
            make.right.equalTo(womenButton.snp_leftMargin).offset(-GBMargin)
            make.size.equalTo(CGSize(width: 34, height: 34))
            make.centerY.equalTo(self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
