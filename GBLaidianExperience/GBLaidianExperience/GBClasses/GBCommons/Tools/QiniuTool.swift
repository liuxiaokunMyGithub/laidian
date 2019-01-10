//
//  QiniuTool.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/8.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

// 七牛云上传图片
class QiniuTool: NSObject {
    static var filePath = String()
    static var sharedInstance = QiniuTool()
    
    var Index : Int = 0
    
    override init() {
    }
    
    // 单图上传
    func uploadImageData(image:Data , result: @escaping (_ progress: Float? , _ imageKey:String? ) -> ()) {
        NetworkTool.shared.post(UrlPath.QiniuToken.rawValue, parameters: nil, methodLog: "七牛Token") { (ResponseStatus, JSON, String) in
            let token = JSON!["data"]["upToken"].string
            if  token != nil {
                let opt = QNUploadOption(mime: nil, progressHandler: {(key, progres) in
                    
                    result(progres, nil)
                }, params: nil, checkCrc: true, cancellationSignal: nil)
                
                var cutdownData : Data!
                if (image.count < 9999) {
                    cutdownData = image
                } else if (image.count < 99999) {
                    let nowImage = UIImage.init(data: image)!
                    cutdownData = nowImage.jpegData(compressionQuality: 0.6)
                } else {
                    let nowImage = UIImage.init(data: image)!
                    cutdownData = nowImage.jpegData(compressionQuality: 0.3)
                }
                
                if let manager = QNUploadManager() {
                    manager.put(cutdownData, key: nil, token: token, complete: { (Info, key, resp) in
                        if (Info?.isConnectionBroken)! {
                           GBToolShowMessage("网络连接失败")
                            return
                        }
                        
                        if let imageKey = resp?["key"] as? String {
                            
                            result(nil, imageKey)
                        }
                        
                    }, option: opt)
                }
            }
        }
    }
    
    // 多图上传
    func upImageDatas(images:[Data] , result: @escaping (_ progress: Float? , _ imageKey:String? ) -> (),allTasksCompletion:@escaping () -> () ) {
        
        if (Index < images.count) {
            
            uploadImageData(image: images[Index], result: { (progres, imageKey) in
                
                if (imageKey != nil) {
                    
                    result(progres, imageKey)
                    
                    self.Index += 1
                    
                    self.upImageDatas(images: images, result: result, allTasksCompletion: allTasksCompletion)
                }
            })
        }else{
            allTasksCompletion()
            Index = 0
        }
        
    }
    
}

// 七牛云上传视频
extension QiniuTool {
    
    func uploadVideoData(video:Data , result: @escaping (_ progress: Float? , _ imageKey:String? ) -> ()) {
        let token = "self.token()"
        
        let opt = QNUploadOption(mime: nil, progressHandler: {(key, progres) in
            
            result(progres, nil)
        }, params: nil, checkCrc: true, cancellationSignal: nil)
        
        
        
        if let manager = QNUploadManager() {
            manager.put(video, key: nil, token: token, complete: { (Info, key, resp) in
                
                if (Info?.isConnectionBroken)! {
                   GBToolShowMessage("网络连接失败")
                    return
                }
                
                if let imageKey = resp?["key"] as? String {
                    
                    result(nil, imageKey)
                }
                
            }, option: opt)
        }
        
    }
    
    func upVideoDatas(videos:[Data] , result: @escaping (_ progress: Float? , _ imageKey:String? ) -> (),allTasksCompletion:@escaping () -> () ) {
        
        if (Index < videos.count) {
            
            uploadVideoData(video: videos[Index], result: { (progres, imageKey) in
                
                if (imageKey != nil) {
                    
                    result(progres, imageKey)
                    
                    self.Index += 1
                    
                    self.upVideoDatas(videos: videos, result: result, allTasksCompletion: allTasksCompletion)
                }
            })
        }else{
            allTasksCompletion()
            Index = 0
        }
        
    }
}
