//
//  XKTextField.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/7.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class XKTextField : UITextField {
    var margin:CGFloat = 0
    // 文字与输入框的距离
    override func textRect(forBounds rect:CGRect) -> CGRect {
        return CGRect.insetBy(rect)(dx:margin == 0 ? 10 : margin, dy: 0)
    }
    // 控制文本的位置
    override func editingRect(forBounds rect:CGRect) -> CGRect {
        return CGRect.insetBy(rect)(dx:margin == 0 ? 10 : margin, dy: 0)
    }
}
