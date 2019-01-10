//
//  GBChangeInfoInputViewController.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/13.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBChangeInfoInputViewController: GBBaseViewController {
    
    var finishBlock:((_ str:String)->())?
    
    lazy var bgView : UIView = {
      let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var detailsTextView: NextGrowingTextView = {
        let textView = NextGrowingTextView()
        textView.maxNumberOfLines = 10
        textView.placeholderAttributedText = NSAttributedString(
            string: "请输入您的签名",
            attributes: [
                .font: XKFont.pingFangSCRegular.size(14) as Any,
                .foregroundColor: kAssistTextColor
            ])
        textView.backgroundColor = .white
        return textView
    }()
    lazy var detailLengthLabel:UILabel = {
        let detail = UILabel()
        detail.textColor = kAssistTextColor
        detail.font = XKFont.pingFangSCRegular.size(12)
        detail.text = "0/60"
        detail.backgroundColor = .white
        detail.textAlignment = .right
        return detail
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSnp()
    }
    
    func setupUI() {
        view.backgroundColor = kBackgroundColor
        view.addSubview(bgView)
        bgView.addSubview(detailsTextView)
        bgView.addSubview(detailLengthLabel)
        
        navBar.wr_setRightButton(title: "完成", titleColor: kBaseColor)
        navBar.onClickRightButton = {
            if self.detailsTextView.textView.text.length > 0 {
                self.finishBlock!(self.detailsTextView.textView.text)
                self.navigationController?.popViewController(animated: true)
            }else {
                GBToolShowMessage("请输入有效信息")
            }
        }
    }

    func addSnp() {
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(kStatusNavigationHeight+8)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(140)
        }
        detailsTextView.snp.makeConstraints { (make) in
            make.top.equalTo(self.bgView)
            make.left.equalTo(self.bgView).offset(GBMargin)
            make.right.equalTo(self.bgView).offset(-GBMargin)
            make.height.equalTo(105)
        }
        detailLengthLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.detailsTextView.snp.bottom).offset(8)
            make.left.equalTo(self.bgView).offset(GBMargin)
            make.right.equalTo(self.bgView).offset(-GBMargin)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
