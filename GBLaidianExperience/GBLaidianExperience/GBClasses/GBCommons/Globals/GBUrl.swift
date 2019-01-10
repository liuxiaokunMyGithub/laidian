//
//  GBUrlApi.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/30.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

let BASE_URL = "http://cs.taijie.work/ld/"
//let BASE_URL = "https://is.snssdk.com"

/** 七牛云图片服务 */
let BASE_URL_IMAGE_QINIUYUN = "http://res.gebihr.com/"

class GBUrl: NSObject {
    class func urlFormater(url:String) -> String {
        // 处理中文空格字符
        var charSet = CharacterSet.urlQueryAllowed
        charSet.insert(charactersIn: "#")
        let urlStr = BASE_URL + url
        return urlStr.addingPercentEncoding(withAllowedCharacters: charSet )!
    }
}

enum UrlPath: String {
    //*------------------
    // MARK: 通用
    //-------------------*
    case QiniuToken   = "misc/qntoken"
    // 文章分类
    case EssayCategory   = "misc/essay/category"
    // 文章有用
    case EssayUseful = "essay/useful"
    // 文章评论
    case EssayCommentList = "essay/comment/list"
    // 文章评论有用
    case EssaycommentUseful = "essay/comment/useful"
    // 阅读文章
    case EssayRead = "essay/read"

    
    //*------------------
    // MARK: 登录
    //-------------------*
    case Login   = "user/login"
    case Login_VerificationCode  = "misc/sendVerificationCode"
    
    //*------------------
    // MARK: 首页
    //-------------------*
    // 首页文章列表
    case HomeEssayList = "essay/search"
    // 发布文章
    case HomePublishEssay = "essay/publish"
   
    
    //*------------------
    // MARK: 发现
    //-------------------*
    // 轮播
    case FindDdvertisement = "misc/advertisement"
    // 活动礼物列表
    case FindGiftList = "gift/list"
    // 参与活动
    case FindParticipate = "gift/activity/participate"

    
    //*------------------
    // MARK: 我的
    //-------------------*
    // 用户基础信息
    case MineUserInfo = "user/info"
    // 更新个人信息
    case MineInfoUpdate = "user/update"
}


enum Rank: Int, CustomStringConvertible { //这里看出 可以使用一个类型--代表rawValue的类型，多个协议--代表这个enum的特性，去定义enum
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king
    
    var description: String {
        switch self {
        case .ace:
            return "A"
        case .jack:
            return "J"
        case .queen:
            return "Q"
        case .king:
            return "K"
        default:
            return String(self.rawValue)
        }
    }
}
