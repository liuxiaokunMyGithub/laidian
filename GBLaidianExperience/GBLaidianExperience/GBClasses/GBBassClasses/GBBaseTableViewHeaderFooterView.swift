//
//  GBBaseTableViewHeaderFooterView.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/5.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

enum BaseHeaderFooterStyle:Int {
    case BaseHeaderFooterStyleCustom = 0
    case BaseHeaderFooterStyleTextDefault = 1
    case BaseHeaderFooterStyleImageDefault = 2
    case BaseHeaderFooterStyleSubtitle = 3
}

class GBBaseTableViewHeaderFooterView: UITableViewHeaderFooterView, Reusable {
    lazy var baseTitleLabel:UILabel = {
        let label = UILabel()
        label.textColor = kImportantTextColor
        label.font = XKFont.pingFangSCMedium.size(16)
        return label
    }()
    lazy var baseDetailLabel:UILabel = {
        let detailLabel = UILabel()
        detailLabel.textColor = kImportantTextColor
        detailLabel.font = XKFont.pingFangSCRegular.size(16)
        return detailLabel
    }()
    lazy var baseImageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var baseIndicateButton:UIButton = {
        let indicateButton = UIButton()
        indicateButton.titleLabel!.font = XKFont.pingFangSCRegular.size(16)
        return indicateButton
    }()
    lazy var baseLineView:UIView = {
        let line = UIView()
        line.backgroundColor = kLineColor
        return line
    }()
    
    var headerFooterStyle: BaseHeaderFooterStyle = .BaseHeaderFooterStyleCustom
    var imageSize:CGSize = CGSize.zero
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        configUI()
    }
    
    open func configUI() {}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.headerFooterStyle == .BaseHeaderFooterStyleCustom {
            return
        }
        
        // 箭头
        addSubview(baseIndicateButton)
        baseIndicateButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-8);
            make.size.equalTo(CGSize(width: 30, height: 30));
            make.centerY.equalTo(self);
        }
        
        // 是否显示图片
        let showImage = self.headerFooterStyle == .BaseHeaderFooterStyleImageDefault
        
        if showImage {
            addSubview(baseImageView)
            baseImageView.snp.makeConstraints { (make) in
                make.left.equalTo(self).offset(GBMargin);
                if imageSize == CGSize.zero {
                    make.size.equalTo(CGSize(width: self.height-GBMargin, height: self.height-GBMargin))
                }else {
                    make.size.equalTo(imageSize)
                }
                make.bottom.equalTo(self);
            }
        }
        
        // title
        addSubview(baseTitleLabel)
        baseTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(showImage ? (baseImageView.snp_rightMargin) : self).offset(GBMargin)
            make.bottom.equalTo(self);
        }
        
        // detail分编辑与不可编辑两种状态
        if self.headerFooterStyle == .BaseHeaderFooterStyleTextDefault {
            addSubview(baseDetailLabel)
            baseDetailLabel.snp.makeConstraints { (make) in
                make.right.equalTo(baseIndicateButton.isHidden ? self : baseIndicateButton.snp_leftMargin).offset(baseIndicateButton.isHidden ? -GBMargin :0);
                make.bottom.equalTo(self);
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print(#function)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}
