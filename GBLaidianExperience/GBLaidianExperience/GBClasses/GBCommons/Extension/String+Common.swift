//
//  String+Common.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/31.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

extension String {
    // 计算文本的宽高
    func textSizeCalculate(font: UIFont, width: CGFloat) -> CGSize {
        return self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).size
    }
    
    /// 计算文本的高度
    func textHeight(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        return textSizeCalculate(font: XKFont.pingFangSCRegular.size(fontSize)!, width: width).height
    }
}
