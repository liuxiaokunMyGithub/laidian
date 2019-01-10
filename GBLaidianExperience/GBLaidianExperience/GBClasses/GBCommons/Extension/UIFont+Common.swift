//
//  UIFont+Common.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/30.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

// 别名枚举类型协议
public protocol FontRepresentable: RawRepresentable {}

extension FontRepresentable where Self.RawValue == String {
    public func size(_ size: CGFloat) -> UIFont? {
        return UIFont(name: rawValue, size: GBRatio * size)
    }
}

// 字体枚举
public enum XKFont: String, FontRepresentable {
    case pingFangSCUltralight = "PingFangSC-Ultralight"
    case pingFangSCRegular = "PingFangSC-Regular"
    case pingFangSCSemibold = "PingFangSC-Semibold"
    case pingFangSCThin = "PingFangSC-Thin"
    case pingFangSCLight = "PingFangSC-Light"
    case pingFangSCMedium = "PingFangSC-Medium"
}

