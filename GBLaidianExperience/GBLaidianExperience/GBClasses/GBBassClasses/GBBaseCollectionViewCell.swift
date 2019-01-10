//
//  GBBaseCollectionViewCell.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/5.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBBaseCollectionViewCell: UICollectionViewCell, Reusable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open func configUI() {}

}
