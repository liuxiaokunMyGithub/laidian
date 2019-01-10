//
//  GBUserModel.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/13.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBUserModel: GBBaseModel {
    var nickName : String = ""
    var headImg : String = ""
    // 个性签名
    var signature : String  = ""
    var sex : String  = ""
    var age : String  = ""
    // 职业
    var occupation : String  = ""
    // 星座
    var constellation : String  = ""
    
    var collectEssayCnt : String!
    var createIncome : Int!
    var income : Int!
    var mutualWatch : Bool!
    var otherIncome : Int!
    var publishCommentCnt : String!
    var realNameAuthed : Bool!
    var totalEssayCnt : String!
    var usefulCnt : String!
    var watchCnt : String!
    var watched : Bool!
    var watchedCnt : String!
    var withdrawAmount : Int!
}
