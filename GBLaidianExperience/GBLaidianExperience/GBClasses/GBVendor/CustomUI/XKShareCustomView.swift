//
//  XKShareCustomView.swift
//  2018
//
//  Created by 刘小坤 on 2018/10/30.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit



protocol XKShareCustomViewProtocol {
    func didClickOnItemAtIndex(index: Int)
}
class XKShareCustomView: UIView {
    let shareMaskView: UIView = {
        let mask = UIView()
        mask.backgroundColor = kImportantTextColor
        mask.frame = UIScreen.main.bounds
        mask.alpha = 0.3
        return mask
    }()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = kSegmentateLineColor
        return scroll
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = kSegmentateLineColor
        label.text = "分享到"
        label.textAlignment = .center
        label.textColor = kImportantTextColor
        label.font = XKFont.pingFangSCRegular.size(16)
        return label
    }()
    //装有图片名字的数组
    var imageArr : [String] = {
        let arr = Array<String>()
        return arr
    }()
    //装有图片title的数组
    var titleArr: [String] = {
        let arr = Array<String>()
        return arr
    }()
    //装有Button的数组
    var meunButtons: [GBUpDownButton] = []
    var delegate: XKShareCustomViewProtocol?
    init(frame: CGRect, buttonInfo: [String:String]) {
        super.init(frame: frame)
        self.imageArr = Array(buttonInfo.keys)
        self.titleArr = Array(buttonInfo.values)
        setupViews()
        ///添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        shareMaskView.isUserInteractionEnabled = true
        shareMaskView.addGestureRecognizer(tap)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(shareMaskView)
        addSubview(scrollView)
        addSubview(titleLabel)
        backgroundColor = .clear
        
        let margenX = 25
        let margenY = 15
        let buttonWeight = 54
        let buttonHeight = 70
        let cancleLabelHeight: CGFloat = 60
        let buttonMargen = (Int(kScreenWidth) - 2 * margenX - 4 * buttonWeight) / 3
        let scrollViewHeight: CGFloat = self.imageArr.count > 4 ? (CGFloat(180 + kBottomSafeAreaHeight)) : (CGFloat(100 + kBottomSafeAreaHeight))
        scrollView.contentSize = CGSize(width: kScreenWidth, height: scrollViewHeight)
        scrollView.frame = CGRect(x: 0, y: kScreenHeight - scrollViewHeight, width: kScreenWidth, height: scrollViewHeight)
        ///循环创建Button
        for i in 0..<self.imageArr.count {
            let customButton = GBUpDownButton()
            customButton.setImage(UIImage(named: self.imageArr[i]), for: .normal)
            customButton.setImage(UIImage(named: self.imageArr[i]), for: .highlighted)
            customButton.setTitle(self.titleArr[i], for: .normal)
            customButton.setTitle(self.titleArr[i], for: .highlighted)
            customButton.setTitleColor(kImportantTextColor, for: .normal)
            customButton.titleLabel?.textAlignment = .center
            customButton.titleLabel?.font = XKFont.pingFangSCRegular.size(12)
            customButton.addTarget(self, action: #selector(menuBtnTouchUpInside(_:)), for: .touchUpInside)
            customButton.tag = 10000 + i
            self.meunButtons.append(customButton)
            let row = i/4
            let col = i%4
            let buttonX = margenX + col * (buttonMargen + buttonWeight )
            var buttonY = margenY + row * (buttonHeight + margenY)
            buttonY += Int(kScreenHeight)
            customButton.frame = CGRect(x: buttonX, y: buttonY, width: buttonWeight, height: buttonHeight)
            customButton.alpha = 0
            scrollView.addSubview(customButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.03 * Double(i), execute: {
                UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
                    customButton.alpha = 1
                    customButton.frame = CGRect(x: buttonX, y: buttonY - Int(kScreenHeight), width: buttonWeight, height: buttonHeight)
                }, completion: nil)
            })
        }
        titleLabel.frame = CGRect(x: 0, y: scrollView.top-cancleLabelHeight, width: kScreenWidth, height: cancleLabelHeight)
    }
    @objc func tap(_ tap :UITapGestureRecognizer) {
        hide()
    }
    @objc func menuBtnTouchUpInside(_ button: GBUpDownButton){
        for customButton in self.meunButtons {
            customButton.titleLabel?.alpha = 0
            UIView.animate(withDuration: 0.35, animations: {
                customButton.alpha = 0
                if customButton.isEqual(button){
                    customButton.imageView?.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
                }else{
                    customButton.imageView?.transform = CGAffineTransform(scaleX: 2, y: 2)
                }
            }, completion: { (bool ) in
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.meunButtons.removeAll()
            self.hide()
        }
        if delegate != nil {
            self.delegate?.didClickOnItemAtIndex(index: button.tag)
        }
    }
    func show(){
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        self.alpha = 1
    }
    func hide(){
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModeLinear, animations: {
            self.alpha = 0
        }) { (finish) in
            self.removeFromSuperview()
        }
    }

}

class LKCustomeButton: UIButton{
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = CGRect(x: 0, y: 0, width: contentRect.size.width, height: contentRect.size.width)
        return rect
    }
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = CGRect(x: 0, y: contentRect.size.width+5, width: contentRect.size.width, height: contentRect.size.height - contentRect.size.width)
        return rect
    }
}


