//
//  Const.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/30.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit
//*------------------
// MARK: 字符常量
//-------------------*
/** 本地保存字符常量key UDK代表UserDefaults Key */
let GBUserDefaults = UserDefaults.standard

let UDK_UserToken = "token"
let UDK_UserId = "userId"
let UDK_SearchHistory = "searchHistoryKey"

/// 文章动态图片的宽高
// 1        screenWidth * 0.5
// 2        (screenWidth - 35) / 2
// 3,4,5-9    (screenWidth - 40) / 3
let image1Width: CGFloat = kScreenWidth * 0.5
let image2Width: CGFloat = (kScreenWidth - 35) * 0.5
let image3Width: CGFloat = (kScreenWidth - 40*GBRatio) / 3

/// emoji 宽度
let emojiItemWidth = kScreenWidth / 7

