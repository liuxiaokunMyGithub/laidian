//
//	GBHomeModel.swift
//
//	Create by 小坤 刘 on 9/11/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 

// 文章分类
class GBEssayCategoryModel: GBBaseModel {
    var id: Int?
    var local: Bool?
    var image: String?
    var name: String?
}

class GBHomeModel : GBBaseModel {
	var category : [String]!
	var commentCnt : Int!
	var content : String!
	var createTime : Int!
	var displayCreateTime : String!
	var id : Int!
	var images : [String]!
	var shared : Bool!
	var title : String!
	var usefulChecked : Bool!
	var usefulCnt : Int!
	var watched : Bool!
}

