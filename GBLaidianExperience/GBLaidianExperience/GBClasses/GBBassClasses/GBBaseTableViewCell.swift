//
//  GBBaseTableViewCell.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/1.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

enum BaseCellStyle:Int {
    case BaseCellStyleCustom = 0
    case BaseCellStyleTextDefault = 1
    case BaseCellStyleImageDefault = 2
    case BaseCellStyleDetailInput = 3
    case BaseCellStyleSubtitle = 4
}

class GBBaseTableViewCell: UITableViewCell, Reusable {
    
    var textValueChangedBlock:((_ valueStr:String)->())?
    
    lazy var baseTitleLabel:UILabel = {
        let label = UILabel()
        label.textColor = kImportantTextColor
        label.font = XKFont.pingFangSCRegular.size(16)
        return label
    }()
    lazy var baseDetailTextField:UITextField = {
        let textField = UITextField()
        textField.textColor = kAssistTextColor
        textField.font = XKFont.pingFangSCRegular.size(16)
        textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        return textField
    }()
    lazy var baseImageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var baseIndicateButton:UIButton = {
        let indicateButton = UIButton()
        indicateButton.setImage(UIImage(named: "icon_more_light"), for: .normal)
        indicateButton.titleLabel!.font = XKFont.pingFangSCRegular.size(16)
        return indicateButton
    }()
    lazy var baseLineView:UIView = {
        let line = UIView()
        line.backgroundColor = kLineColor
        return line
    }()
    
    var cellStyle: BaseCellStyle = .BaseCellStyleCustom
    
    var linWidth = CGFloat()
    
    var imageSize:CGSize = CGSize.zero

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configUI()
    }
    
    open func configUI() {}
    
    @objc open func textFieldValueChanged(_ textField: UITextField) {
        self.textValueChangedBlock!(textField.text!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.cellStyle == .BaseCellStyleCustom {
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
        let showImage = self.cellStyle == .BaseCellStyleImageDefault
        
        if showImage {
            addSubview(baseImageView)
            baseImageView.snp.makeConstraints { (make) in
                make.left.equalTo(self).offset(GBMargin);
                if imageSize == CGSize.zero {
                make.size.equalTo(CGSize(width: self.height-GBMargin, height: self.height-GBMargin))
                }else {
                    make.size.equalTo(imageSize)
                }
                make.centerY.equalTo(self)
            }
        }
        
        // title
        addSubview(baseTitleLabel)
        baseTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(showImage ? (baseImageView.snp_rightMargin) : self).offset(GBMargin)
            make.centerY.equalTo(self);
        }
        
        // detail分编辑与不可编辑两种状态
        if self.cellStyle == .BaseCellStyleTextDefault || self.cellStyle == .BaseCellStyleDetailInput {
            addSubview(baseDetailTextField)
            // 是否可以编辑
            baseDetailTextField.isUserInteractionEnabled = self.cellStyle == .BaseCellStyleDetailInput
            
            baseDetailTextField.snp.makeConstraints { (make) in
                make.right.equalTo(baseIndicateButton.isHidden ? self : baseIndicateButton.snp_leftMargin).offset(baseIndicateButton.isHidden ? -GBMargin :0);
                make.centerY.equalTo(self);
            }
        }
        // 线
        addSubview(baseLineView)
        baseLineView.snp.makeConstraints { (make) in
            make.left.equalTo(linWidth == kScreenWidth ? 0 : GBMargin);
            make.right.equalTo(self).offset(linWidth == kScreenWidth ? 0 : -GBMargin);
            make.height.equalTo(0.5)
            make.bottom.equalTo(self)
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
  
}
