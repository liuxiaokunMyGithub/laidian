//
//  UIColor+Common.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/30.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

extension UIColor {
    /// 获取颜色的方法
    /**
     获取颜色，通过16进制色值字符串，e.g. #ff0000， ff0000
     - parameter hexString  : 16进制字符串
     - parameter alpha      : 透明度，默认为1，不透明
     - returns: RGB
     */
    static func ColorFromHexStr(hexString hex: String, alpha:CGFloat = 1) -> UIColor {
        // 去除空格等
        var cString: String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        // 去除#
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        // 必须为6位
        if (cString.count != 6) {
            return UIColor.gray
        }
        // 红色的色值
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        // 字符串转换
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    /**
     获取颜色，通过16进制数值
     - parameter hexInt : 16进制数值
     - parameter alpha  : 透明度
     - returns : 颜色
     */
    static func ColorFromHex(hexInt hex:Int32, alpha:CGFloat = 1) -> UIColor {
        let r = CGFloat((hex & 0xff0000) >> 16) / 255
        let g = CGFloat((hex & 0xff00) >> 8) / 255
        let b = CGFloat(hex & 0xff) / 255
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
    /**
     获取颜色，通过rgb
     - parameter red    : 红色
     - parameter green  : 绿色
     - parameter blue   : 蓝色
     - returns : 颜色
     */
    static func RGB(_ red:CGFloat, _ green:CGFloat, _ blue:CGFloat) -> UIColor {
        return UIColor.RGBA(red, green, blue, 1)
    }
    
    /**
     获取颜色，通过rgb
     - parameter red    : 红色
     - parameter green  : 绿色
     - parameter blue   : 蓝色
     - parameter alpha  : 透明度
     - returns : 颜色
     */
    static func RGBA(_ red:CGFloat, _ green:CGFloat, _ blue:CGFloat, _ alpha:CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
}

extension UIColor {
    func toImage() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        self.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

// 基本主色调
let kBaseColor = UIColor.ColorFromHexStr(hexString: "#03BFFF")
// 模块浅灰背景色
let kBackgroundColor = UIColor.ColorFromHexStr(hexString: "#F7F7F7")
// 分组线颜色
let kSegmentateLineColor = UIColor.ColorFromHexStr(hexString: "#F0F0F0")
// 分割线颜色
let kLineColor = UIColor.ColorFromHexStr(hexString: "#DDDDDD")
// 重要文字颜色
let kImportantTextColor = UIColor.ColorFromHexStr(hexString: "#333333")
// 普通文字颜色
let kNormoalTextColor = UIColor.ColorFromHexStr(hexString: "#666666")
// 辅助信息 时间日期等文字颜色
let kAssistTextColor = UIColor.ColorFromHexStr(hexString: "#888888")
// 红色文字颜色
let kRedTextColor = UIColor.ColorFromHexStr(hexString: "#EF4F20")


