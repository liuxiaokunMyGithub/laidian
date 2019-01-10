//
//  WordLimit.swift
//  UITextField&textView_WordLimit
//
//  Created by 石文文 on 16/7/7.
//  Copyright © 2016年 石文文. All rights reserved.
//

import UIKit
//import ObjectiveC

private var textFieldTextLength = "textFieldTextLength"
public let UITextFieldTextLengthDidChangeNotification: String = "UITextFieldTextLengthDidChangeNotification"


public extension UITextField{
    
    
    /// 最大输入长度
    public  var maxCharLength:Int{
        //通过运行时添加实例属性
        set{
            
            objc_setAssociatedObject(self, &textFieldTextLength, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            
            
            self.addTarget(self, action: #selector(UITextField.textFieldEditingChange(textField:)), for: .editingChanged)
            
            
        }
        get{
            
            return (objc_getAssociatedObject(self, &textFieldTextLength) as? Int)!
            
        }
        
    }
    
    /**
     编辑中
     
     - parameter textField: 当前编辑的textField
     */
    @objc func textFieldEditingChange(textField:UITextField ) {
        
        if let _ = textField.text {
            if let positionRange = textField.markedTextRange {
                
                if let _ = textField.position(from: positionRange.start, offset: 0) {
                    //正在使用拼音，不进行校验
                    
                    
                    
                } else {
                    //不在使用拼音，进行校验
                    
                    self.checkLength(textField: textField)
                }
                
            } else {
                
                //不在使用拼音，进行校验
                self.checkLength(textField: textField)
            }
        }
        
    }
    
    
    /**
     长度检测
     
     - parameter textField: 当前检测的textField
     */
    func checkLength(textField:UITextField) {
        if let text = textField.text {
            if text.length <= self.maxCharLength {
                //长度正常，不处理
                
                //                print(text.length)
                
                //发送通知
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: UITextFieldTextLengthDidChangeNotification), object: self)
                
                
                
            } else {
                
                //超出长度，开始处理
                print("输入文字过长")
                
                let len = text.length
                
                if len > 0 {
                    
                    //进行截取
                    
                    for i in 1..<len {
                        
                        let j = len - i
                        
                        let txt:String = String(text.prefix(j))
                        if  txt.length <= self.maxCharLength{
                            //截取结束
                            textField.text = txt
                            //发送通知
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: UITextFieldTextLengthDidChangeNotification), object: self)
                            
                            break
                        }
                    }
                    
                }
            }
        }
        
        
        
    }
    
    
    
}



private var textViewTextLength = "textViewTextLength"
public let UITextViewTextLengthDidChangeNotification: String = "UITextViewTextLengthDidChangeNotification"

extension UITextView {
    
    
    /// 最大输入长度
    public  var maxCharLength:Int{
        //通过运行时添加实例属性
        set{
            
            objc_setAssociatedObject(self, &textViewTextLength, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(UITextView.textViewEditingLengthChange), name: UITextView.textDidChangeNotification, object:nil)
            
            
        }
        get{
            
            return (objc_getAssociatedObject(self, &textViewTextLength) as? Int)!
            
        }
        
    }
    
    /**
     编辑中
     
     - parameter textView: 当前编辑的textView
     */
    @objc func textViewEditingLengthChange() {
        
        if let _ = self.text {
            if let positionRange = self.markedTextRange {
                
                if let _ = self.position(from: positionRange.start, offset: 0) {
                    //正在使用拼音，不进行校验
                    
                    
                    
                } else {
                    //不在使用拼音，进行校验
                    
                    self.checkLength()
                }
                
            } else {
                
                //不在使用拼音，进行校验
                self.checkLength()
            }
        }
        
    }
    
    
    /**
     长度检测
     
     - parameter textView: 当前检测的textView
     */
    func checkLength() {
        if let text = self.text {
            if text.length <= self.maxCharLength {
                //长度正常，不处理
                
                //                print(text.length)
                
                //发送通知
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: UITextViewTextLengthDidChangeNotification), object: self)
                
                
            } else {
                
                //超出长度，开始处理
                print("输入文字过长")
                
                let len = text.length
                
                if len > 0 {
                    
                    //进行截取
                    
                    for i in 1..<len {
                        
                        let j = len - i
                        
                        let txt:String = String(text.prefix(j))
                        //                        print("txt : \(txt)")
                        if  txt.length <= self.maxCharLength{
                            //截取结束
                            self.text = txt
                            //发送通知
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: UITextViewTextLengthDidChangeNotification), object: self)
                            break
                        }
                    }
                    
                }
            }
        }
        
        
        
    }
    
    
    
    
    
    
}

extension String{
    
    /// 字符串长度
    
    var length:Int{
        
        
        get{
            
            return self.characters.count
            
        }
        
        
    }
    
    
}
