//
//  GBGlobals.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/30.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

//*------------------
// MARK: 第三方库全局导入
//-------------------*
@_exported import Alamofire
@_exported import SwiftyJSON
@_exported import MJRefresh
@_exported import MBProgressHUD
@_exported import SnapKit
@_exported import Reusable
@_exported import SLGenericsNineView
@_exported import LTScrollView
@_exported import RxSwift
@_exported import RxCocoa
@_exported import Kingfisher
@_exported import HandyJSON
@_exported import Qiniu
@_exported import IQKeyboardManagerSwift

//*------------------
// MARK: UI相关
//-------------------*

let isIPhoneX: Bool = kStatusBarHeight == 44 ? true : false

// 主窗口视图
let KEYWINDOW = UIApplication.shared.keyWindow
// 屏幕宽
let kScreenWidth = UIScreen.main.bounds.width
// 屏幕高
let kScreenHeight = UIScreen.main.bounds.height

//状态栏高度
let kStatusBarHeight = UIApplication.shared.statusBarFrame.height;
//导航栏高度
let kNavigationHeight = CGFloat(44)
//导航状态栏高度
let kStatusNavigationHeight = kStatusBarHeight + kNavigationHeight

//tabbar高度
let kTabBarHeight = CGFloat((kStatusBarHeight == 44 ? 83 : 49))
//顶部的安全距离
let kTopSafeAreaHeight = (kStatusBarHeight - 20)
//底部的安全距离
let kBottomSafeAreaHeight = (kTabBarHeight - 49)

// 边沿距离
let GBMargin = CGFloat(16)

/** 以iPhone6设计稿宽为基准比例适配 */
let GBRatio = kScreenWidth / 375

//MARK: SnapKit
extension ConstraintView {
    var safeSnp: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        } else {
            return self.snp
        }
    }
}


