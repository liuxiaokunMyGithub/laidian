//
//  GBTool.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/5.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

//*------------------
// MARK: 工具方法
//-------------------*

// 自定义Log
func GBLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    let timeStr:String = getCurrentTime()
    print("\(timeStr) \(fileName) 第\(lineNum)行:\n\(message)\n");
    #endif
}

// 提示消息
func GBToolShowMessage(_ message:String) {
    GBToolShowMessage(message, timeintevel: 1.5)
}

func GBToolShowMessage(_ message:String , timeintevel:CGFloat) {
    let hud = MBProgressHUD.showAdded(to: KEYWINDOW!, animated: true)
    hud.mode = MBProgressHUDMode.text
    hud.label.text = message
    hud.label.font = XKFont.pingFangSCRegular.size(14)
    hud.label.textColor = .white
    hud.bezelView.style = MBProgressHUDBackgroundStyle.solidColor
    hud.bezelView.backgroundColor = .black
    hud.margin = 5;
    hud.bezelView.layer.cornerRadius = 2;
    
    hud.removeFromSuperViewOnHide = true;
    hud.hide(animated: true, afterDelay: TimeInterval(timeintevel))
}

// 适配UI
func GBToolFitUI(_ height_width:CGFloat) -> CGFloat {
    return height_width*GBRatio
}

// MARK: 设置圆角
func GBToolConfigRadius(_ view: UIView, radius:CGFloat) {
    GBToolConfigRadius(view,radius: radius,rectCorner: [.allCorners])
}

func GBToolConfigRadius(_ view: UIView, radius:CGFloat,rectCorner:UIRectCorner) {
    let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: radius, height: radius))
    let maskLayer = CAShapeLayer.init()
    maskLayer.path = maskPath.cgPath
    view.layer.mask = maskLayer
}

// MARK: 设置圆角边框
func GBToolConfigBorderRadius (_ view:UIView, radius:CGFloat, width:CGFloat,color:UIColor) {
    GBToolConfigBorderRadius(view, radius: radius, top:true, left: true, bottom: true, right: true, width: width, color: color)
}

func GBToolConfigBorderRadius (_ view:UIView,radius:CGFloat,top:Bool,left:Bool,bottom:Bool,right:Bool,width:CGFloat,color:UIColor)
{
    if top {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: view.width, height: width)
        layer.backgroundColor = color.cgColor
        view.layer.addSublayer(layer)
    }
    
    if left {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: width, height: view.height)
        layer.backgroundColor = color.cgColor
        view.layer.addSublayer(layer)
    }
    
    if bottom {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: view.frame.size.height - width, width: view.width, height: width)
        layer.backgroundColor = color.cgColor
        view.layer.addSublayer(layer)
    }
    
    if right {
        let layer = CALayer()
        layer.frame = CGRect(x: view.frame.size.width - width, y: 0, width: width, height: view.height)
        layer.backgroundColor = color.cgColor
        view.layer.addSublayer(layer)
    }
    
    GBToolConfigRadius(view, radius: radius)
}

// 字符串部分字符显示不同颜色字体
func GBToolChangePartOfStringStyle(allString:String,rangeString:String,color:UIColor,font:UIFont) -> NSMutableAttributedString
{
    let attriStr:NSMutableAttributedString = NSMutableAttributedString(string:allString)
    let range = NSMakeRange(NSString(string: allString).range(of: rangeString).location, NSString(string: allString).range(of: rangeString).length)
    attriStr.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: (range ))
    
    attriStr.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    
    return attriStr
}

// 当前导航控制器
let GBPushNavigationController = getPushNavigationController()

func getPushNavigationController() -> UINavigationController {
    let tabBarController = KEYWINDOW?.rootViewController as! UITabBarController
    let nav = tabBarController.selectedViewController
    return nav as! UINavigationController
}

func GBToolAddAcrossPartingLine(_ view:UIView,color:UIColor,atTop:Bool = true) {
    let cellAcrossPartingLine = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 0.5))
    cellAcrossPartingLine.backgroundColor = color;
    view.addSubview(cellAcrossPartingLine)
    view.bringSubviewToFront(cellAcrossPartingLine)
    
    cellAcrossPartingLine.snp.makeConstraints { (make) in
        make.left.right.equalTo(view)
        make.right.equalTo(view)
        make.height.equalTo(0.5)
        if atTop == true  {
            make.top.equalTo(view)
        }else {
            make.bottom.equalTo(view)
        }
    }
    
}





