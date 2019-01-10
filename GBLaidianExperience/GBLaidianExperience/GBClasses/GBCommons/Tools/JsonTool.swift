//
//  JsonTool.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/12.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class JsonTool: NSObject {
    /**
     *  Json转对象
     */
    static func jsonToModel(_ jsonStr:String,_ modelType:HandyJSON.Type) ->GBBaseModel {
        if jsonStr == "" || jsonStr.count == 0 {
            #if DEBUG
            print("jsonoModel:字符串为空")
            #endif
            return GBBaseModel()
        }
        return modelType.deserialize(from: jsonStr)  as! GBBaseModel
        
    }
    
    /**
     *  Json转数组对象
     */
    static func jsonArrayToModel(_ jsonArrayStr:String, _ modelType:HandyJSON.Type) ->[GBBaseModel] {
        if jsonArrayStr == "" || jsonArrayStr.count == 0 {
            #if DEBUG
            print("jsonToModelArray:字符串为空")
            #endif
            return []
        }
        var modelArray:[GBBaseModel] = []
        let data = jsonArrayStr.data(using: String.Encoding.utf8)
        let peoplesArray = try! JSONSerialization.jsonObject(with:data!, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
        for people in peoplesArray! {
            modelArray.append(dictionaryToModel(people as! [String : Any], modelType))
        }
        return modelArray
        
    }
    
    /**
     *  字典转对象
     */
    static func dictionaryToModel(_ dictionStr:[String:Any],_ modelType:HandyJSON.Type) -> GBBaseModel {
        if dictionStr.count == 0 {
            #if DEBUG
            print("dictionaryToModel:字符串为空")
            #endif
            return GBBaseModel()
        }
        return modelType.deserialize(from: dictionStr) as! GBBaseModel
    }
    
    /**
     *  字典数组转对象数组
     */
    static func dictionaryArrayToModelArray(_ dictionArray:[Any],_ modelType:HandyJSON.Type) -> [GBBaseModel] {
        if dictionArray.count == 0 {
            #if DEBUG
            print("dictionaryArrayToModelArray:字典数组为空")
            #endif
            return [GBBaseModel]()
        }
        var modelArray:[GBBaseModel] = []
        
        for people in dictionArray {
            modelArray.append(dictionaryToModel(people as! [String : Any], modelType))
        }
        return modelArray
    }
    
    /**
     *  对象转JSON
     */
    static func modelToJson(_ model:GBBaseModel?) -> String {
        if model == nil {
            #if DEBUG
            print("modelToJson:model为空")
            #endif
            return ""
        }
        return (model?.toJSONString())!
    }
    
    /**
     *  对象转字典
     */
    static func modelToDictionary(_ model:GBBaseModel?) -> [String:Any] {
        if model == nil {
            #if DEBUG
            print("modelToJson:model为空")
            #endif
            return [:]
        }
        return (model?.toJSON())!
    }
    
}
