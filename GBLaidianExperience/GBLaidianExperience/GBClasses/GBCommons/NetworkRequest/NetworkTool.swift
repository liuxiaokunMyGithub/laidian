//
//  NetworkTool.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/30.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit
import Alamofire
//import SwiftyJSON

/// 请求响应状态
///
/// - success: 响应成功
/// - unusual: 响应异常
/// - failure: 请求错误
enum ResponseStatus: Int {
    case success  = 0
    case unusual  = 1
    case failure  = 3
}

/// 网络请求回调闭包 status:响应状态 result:JSON tipString:提示给用户的信息
typealias NetworkFinished = ((state: ResponseStatus, result: JSON?, message: String?)) -> ()

class NetworkTool: NSObject {
    
    // 网络工具类单例
    static let shared = NetworkTool()
    
    // 服务器域名
    var rootDomain: String {
        #if DEBUG
        return BASE_URL
        #else
        return BASE_URL
        #endif
    }
    
    // 网络请求管理对象
    private var alamofireManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        return Alamofire.SessionManager(configuration: configuration)
    }();
}

// MARK: - 基础请求方法
extension NetworkTool {
    //    in view: UIView = UIApplication.shared.keyWindow!,title: String? = nil
    // 获取请求头
    fileprivate func headers() -> Dictionary<String, String>! {
        let headers:NSMutableDictionary = NSMutableDictionary.init(dictionary: [
            "Content-type":"application/json",
            "Accept":"application/json",
            ])
        if (GBUserDefaults.value(forKey: UDK_UserToken) != nil) {
            headers.addEntries(from: ["Token":GBUserDefaults.value(forKey: UDK_UserToken) as Any])
        }
        if (GBUserDefaults.value(forKey: UDK_UserId) != nil) {
            headers.addEntries(from: ["Uid": GBUserDefaults.string(forKey:UDK_UserId) as Any])
        }
        return (headers as! Dictionary<String, String>)
    }
    
    /**
     GET请求
     
     - parameter URLString:  urlString
     - parameter parameters: 参数
     - parameter finished:   完成回调
     */
    func get(_ APIString: String, parameters: [String : Any]?, needHeaders: Bool = true, needLoading: Bool = false,methodLog: String, finished: @escaping NetworkFinished) {
        
        if needLoading {
            // HexaLoading.show(in: UIApplication.shared.keyWindow!)
        }
        
        let headers = needHeaders ? self.headers() : nil
        
        GBLog("🌎🌎🌎\n\(methodLog)Request: \nURL: \(rootDomain + APIString)\nMethod: get\nHeaders:\(String(describing: headers))\nParameters: \(String(describing: parameters))")
        
        self.alamofireManager.request(rootDomain + APIString, method: .get, parameters: parameters, headers: headers).responseJSON { (response) in
            self.handle(response: response, finished: finished, needLoading: needLoading,methodLog:methodLog)
        }
    }
    
    /**
     POST请求
     
     - parameter URLString:  urlString
     - parameter parameters: 参数
     - parameter finished:   完成回调
     */
    func post(_ APIString: String, parameters: [String : Any]?, needHeaders: Bool = true, needLoading: Bool = false,methodLog: String, finished: @escaping NetworkFinished) {
        
        if needLoading {
            // HexaLoading.show()
        }
        
        let headers = needHeaders ? self.headers() : nil
        
        GBLog("🌎🌎🌎\n\(methodLog)~Request: \nURL: \(rootDomain + APIString)\nMethod: post\nHeaders:\(String(describing: headers))\nParameters: \(String(describing: parameters))")
        
        self.alamofireManager.request(rootDomain + APIString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
            self.handle(response: response, finished: finished, needLoading: needLoading,methodLog:methodLog)
        }
    }
    
    
    /**
     处理响应结果
     
     - parameter:
     - response:  响应对象
     - finished: 完成回调
     */
    fileprivate func handle(response: DataResponse<Any>, finished: @escaping NetworkFinished, needLoading: Bool,methodLog: String) {
        
        if needLoading {
            //            HexaLoading.hide()
        }
        
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            GBLog("\(methodLog)~Response:\(json)")
            if json["status"] == 200 {
                finished((state: .success,result:  json,message: json["desc"].string))
            } else {
                finished((state:.unusual, result: json, message: json["desc"].string))
                GBToolShowMessage(json["desc"].string!)
            }
        case .failure(let error):
            finished((state: .failure, result: nil, message: error.localizedDescription))
            GBToolShowMessage("数据加载失败")
        }
    }
}

