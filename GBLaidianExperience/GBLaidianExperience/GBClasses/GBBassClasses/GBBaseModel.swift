//
//  GBBaseModel.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/12.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

class GBBaseModel: HandyJSON {
    //    var date: Date?
    //    var decimal: NSDecimalNumber?
    //    var url: URL?
    //    var data: Data?
    //    var color: UIColor?
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        /* 自定义解析规则，日期数字颜色，如果要指定解析格式，子类实现重写此方法即可
         mapper <<<
         date <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd")
         
         mapper <<<
         decimal <-- NSDecimalNumberTransform()
         
         mapper <<<
         url <-- URLTransform(shouldEncodeURLString: false)
         
         mapper <<<
         data <-- DataTransform()
         
         mapper <<<
         color <-- HexColorTransform()
         */
    }
}

