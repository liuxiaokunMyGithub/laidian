//
//  GBClassificationTableViewCell.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/4.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit


class GBClassificationTableViewCell: GBBaseTableViewCell {
    var categoryList = [GBEssayCategoryModel]()
    var classificationView:SLGenericsNineView<UIImageView,GBEssayCategoryModel>!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        classificationView = SLGenericsNineView(totalWidth:kScreenWidth , map: { (imageView, model) in
            imageView.kf.setImage(with: URL(string:BASE_URL_IMAGE_QINIUYUN + model.image!), placeholder:UIImage(named: "banner01"))
            imageView.isUserInteractionEnabled = true
            imageView.backgroundColor = .red
            imageView.contentMode = .scaleAspectFill
            GBToolConfigRadius(imageView, radius: 4)
        })
        
        self.contentView.addSubview(classificationView)
        classificationView.dataArr = categoryList
        classificationView.horizontalSpace = 12
        classificationView.verticalSpace = 12
        classificationView.topMargin = 15
        classificationView.leftMargin = 15
        classificationView.rightMargin = 15
        classificationView.everyRowCount = 2
        classificationView.reLayoutSubViews()
        classificationView.backgroundColor = .white

        classificationView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        
        classificationView.itemClicked = {(view, model, index) in
            GBLog(index)
        }
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
