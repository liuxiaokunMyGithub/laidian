//
//  GBGiftTableViewCell.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/5.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBGiftTableViewCell: GBBaseTableViewCell {
    var giftModel = GBGiftModel() {
        didSet {
            baseTitleLabel.text = giftModel.title
            baseDetailTextField.attributedText = GBToolChangePartOfStringStyle(allString: "官方售价 \(giftModel.price!) 元", rangeString: "\(giftModel.price!) 元", color: kRedTextColor, font: XKFont.pingFangSCMedium.size(16)!)
            baseImageView.kf.setImage(with: URL(string:BASE_URL_IMAGE_QINIUYUN + giftModel.displayImg!), placeholder:UIImage(named: "banner01"))
            
        }
    }
    
    override func configUI() {
        baseTitleLabel.numberOfLines = 2
        baseTitleLabel.font = XKFont.pingFangSCMedium.size(16)
        baseIndicateButton.setTitle("点击报名免费送", for: .normal)
        baseIndicateButton.setTitleColor(kRedTextColor, for: .normal)
        baseIndicateButton.setImage(nil, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(baseImageView)
        addSubview(baseTitleLabel)
        addSubview(baseDetailTextField)
        addSubview(baseIndicateButton)
        
        baseImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(GBMargin);                     make.size.equalTo(CGSize(width: GBToolFitUI(135), height: GBToolFitUI(138)))
            make.top.equalTo(self).offset(16)
            make.bottom.equalTo(self)
        }
        
        baseTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(baseImageView.snp.right).offset(GBMargin);                     make.right.equalTo(self).offset(-GBMargin);
            make.top.equalTo(baseImageView)
        }
        
        baseDetailTextField.snp.makeConstraints { (make) in
            make.left.equalTo(baseImageView.snp.right).offset(GBMargin);                     make.right.equalTo(self).offset(-GBMargin);
            make.top.equalTo(baseTitleLabel.snp.bottom).offset(GBToolFitUI(8))
                make.height.equalTo(22)
        }
        
        baseIndicateButton.snp.makeConstraints { (make) in
            make.left.equalTo(baseImageView.snp.right).offset(GBMargin);                     make.right.equalTo(self).offset(-GBMargin);
            make.bottom.equalTo(baseImageView)
            make.height.equalTo(44)
        }
        
        GBToolConfigBorderRadius(baseIndicateButton, radius: 2, width: 1, color: kRedTextColor)
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
