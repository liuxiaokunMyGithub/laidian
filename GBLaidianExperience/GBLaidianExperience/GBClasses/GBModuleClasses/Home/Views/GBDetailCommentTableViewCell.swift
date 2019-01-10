//
//  GBDetailCommentTableViewCell.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/15.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBDetailCommentTableViewCell: GBBaseTableViewCell {
    lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.textColor = kAssistTextColor
        label.font = XKFont.pingFangSCLight.size(12)
        return label
    }()
    
    override func configUI() {
        self.contentView.addSubview(baseImageView)
        self.contentView.addSubview(baseTitleLabel)
        self.contentView.addSubview(baseDetailTextField)
        self.contentView.addSubview(baseLineView)
        self.contentView.addSubview(baseIndicateButton)
        self.contentView.addSubview(timeLabel)
        
        addSnp()
        
        GBToolConfigRadius(baseImageView, radius: 20)
    }
    
    func addSnp() {
        baseImageView.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(GBMargin);
            make.width.height.equalTo(40)
        }
        
        baseTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(baseImageView).offset(GBMargin)
            make.right.equalTo(self.contentView).offset(-GBMargin)
        }
        
        baseDetailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(baseTitleLabel.snp.bottom).offset(5)
            make.left.equalTo(baseImageView).offset(GBMargin)
            make.right.equalTo(self.contentView).offset(-GBMargin)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(baseDetailTextField.snp.bottom).offset(GBMargin)
            make.left.equalTo(baseImageView).offset(GBMargin)
        }
        baseIndicateButton.snp.makeConstraints { (make) in
            make.top.equalTo(baseDetailTextField.snp.bottom).offset(GBMargin)
            make.left.equalTo(baseImageView).offset(GBMargin)
            make.right.equalTo(self.contentView).offset(-GBMargin)
        }
        baseLineView.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(5)
            make.left.equalTo(baseImageView).offset(GBMargin)
            make.right.equalTo(self.contentView)
            make.height.equalTo(0.5)
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
