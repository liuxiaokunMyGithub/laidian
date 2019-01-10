//
//  UIKit+Extension.swift
//  News
//
//  Created by 杨蒙 on 2017/12/12.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import UIKit
import CoreText

extension UIView {
    public var left: CGFloat {
        get{
            return self.frame.origin.x
        }
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    public var right: CGFloat {
        get{
            return self.frame.origin.x + self.frame.size.width
        }
        set{
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width
            self.frame = frame
        }
    }
    
    public var top: CGFloat {
        get{
            return self.frame.origin.y
        }
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    public var bottom: CGFloat {
        get{
            return self.frame.origin.y + self.frame.size.height
        }
        set{
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }
    
    public var centerX: CGFloat {
        get{
            return self.center.x
        }
        set{
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    public var centerY: CGFloat {
        get{
            return self.center.y
        }
        set{
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    public var width: CGFloat {
        get{
            return self.frame.size.width
        }
        set{
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    public var height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    public var size: CGSize {
        get{
            return self.frame.size
        }
        set{
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    public var origin: CGPoint {
        get{
            return self.frame.origin
        }
        set{
            var frame = self.frame
            frame.origin = origin
            self.frame = frame
        }
    }
    
}

extension UIImageView {
    /// 设置图片圆角
    func circleImage() {
        /// 建立上下文
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        /// 获取当前上下文
        let ctx = UIGraphicsGetCurrentContext()
        /// 添加一个圆，并裁剪
        ctx?.addEllipse(in: self.bounds)
        ctx?.clip()
        /// 绘制图像
        self.draw(self.bounds)
        /// 获取绘制的图像
        let image = UIGraphicsGetImageFromCurrentImageContext()
        /// 关闭上下文
        UIGraphicsEndImageContext()
        DispatchQueue.global().async {
            self.image = image
        }
    }
    
}

extension UITextView {
    
    /// 设置 UITextView 富文本内容
    func setAttributedText(emoji: Emoji) {
        // 如果输入是空表情
        if emoji.isEmpty { return }
        // 如果输入是删除表情
        if emoji.isDelete { deleteBackward(); return }
        
        // 创建附件
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: emoji.png)
        // 当前字体的大小
        let currentFont = font!
        // 附件的大小
        attachment.bounds = CGRect(x: 0, y: -4, width: currentFont.lineHeight, height: currentFont.lineHeight)
        // 根据附件，创建富文本
        let attributedImageStr = NSAttributedString(attachment: attachment)
        // 获取当前的光标的位置
        let range = selectedRange
        // 设置富文本
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        mutableAttributedText.replaceCharacters(in: range, with: attributedImageStr)
        attributedText = mutableAttributedText
        // 将字体的大小重置
        font = currentFont
        // 光标 + 1
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
    
}
